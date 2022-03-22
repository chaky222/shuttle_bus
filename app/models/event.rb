# frozen_string_literal: true

class Event < ApplicationRecord
  NO_LOGO_IMG_PATH = '/pics/no_image.png'.freeze

  belongs_to :user

  has_many :event_props, dependent: :destroy
  has_many :event_ticket_packs, dependent: :destroy
  has_many :tickets, through: :event_ticket_packs
  has_many :payed_tickets, -> { where("tickets.ticket_payed_at IS NOT NULL") }, through: :event_ticket_packs, source: :tickets
  has_many :event_chat_msgs, dependent: :destroy
  has_many :event_imgs, -> { order(prio: :asc, id: :asc) }, dependent: :destroy
  has_many :users_with_ticket, -> { distinct }, through: :payed_tickets, source: :user
  has_many :reports, dependent: :destroy, inverse_of: :event
  has_many :reviews, as: :assessable

  validates :name, length: { in: 2..300 }, presence: true
  validates :description, length: { maximum: 2000 }
  validates :declined_at, strict: true, before_time_as_const: Time.now
  validate :event_start_time_is_possible?
  validate :visibility_status_possible?

  before_save :refill_event_rang_pts, :refill_search_text

  after_validation :reverse_geocode, if: ->(e) {
    (e.latitude.present? && e.longitude.present?) && (e.latitude_changed? || e.longitude_changed?)
  }

  after_save :refill_event_props

  reverse_geocoded_by :latitude, :longitude do |e, results|
    geo = results.first

    if geo.present?
      e.address = geo.address
      e.geography = geo.data['address']
    end
  end

  enum visibility_status: {
    not_published: 0,
    canceled: 1,
    unpublished: 3,
    published: 8,
    finished: 9
  }, _prefix: :visibility_status

  scope :not_published, -> { where(visibility_status: :not_published) }
  scope :published, -> { where(visibility_status: :published) }
  scope :canceled, -> { where(visibility_status: :canceled) }
  scope :finished, -> { where(visibility_status: :finished) }

  def visibility_status_id; self.class.visibility_statuses[visibility_status]; end
  def event_start_time_with_default; event_start_time || (Time.now + 2.hours).localtime; end
  def event_finish_time_with_default; event_finish_time || (Time.now + 3.hours).localtime; end
  def event_start_time_unixtime; event_start_time.nil? ? nil : event_start_time.to_time.to_i; end
  def event_finish_time_unixtime; event_finish_time.nil? ? nil : event_finish_time.to_time.to_i; end
  def declined_at_unixtime; declined_at.nil? ? nil : declined_at.to_time.to_i; end
  def event_actual?; (!(new_record?)); end # TODO need logic with status check here.
  def client_default_url; "/parties/#{ id }"; end
  def self.profile_list_url; '/profile/my_events'; end
  def profile_default_url; "#{ self.class.profile_list_url }/#{ id ? id : 'new' }"; end
  def profile_event_images_list_url; "#{ profile_default_url }/images"; end
  def client_event_name_html; "<span class='client_event_name_span'>Event \##{ id }</span>".html_safe; end


  def calc_payout_sum_eur; (calc_payout_sum_eur_cts / 100.0); end
  def calc_payout_sum_eur_cts
    result = 0
    event_ticket_packs.each do |tpack|
      tpack.tickets.each do |ticket|
        if ticket.ticket_fully_payed? && (ticket.ticket_payed_sum_cts >= ticket.for_owner_eur_cts)
          result += ticket.for_owner_eur_cts
        end
      end
    end
    result
  end

  def calc_payed_sum_eur; (calc_payed_sum_eur_cts / 100.0); end
  def calc_payed_sum_eur_cts
    result = 0
    event_ticket_packs.each do |tpack|
      tpack.tickets.each do |ticket|
        result += ticket.ticket_payed_sum_cts
      end
    end
    result
  end

  def event_locked_for_owner_edit?; false; end

  def can_owner_publish_this_event?; (event_still_actual?) && (!(visibility_status_published?)); end
  def can_owner_edit_this_event?; (calc_payed_sum_eur_cts.zero?); end
  def can_owner_return_to_unpublished?; can_owner_edit_this_event? && visibility_status_published?; end
  def can_owner_decline_this_event?; can_owner_edit_this_event? && visibility_status_id.positive? && (!(visibility_status_canceled?)); end
  def event_already_started?; event_start_time_with_default <= Time.now.localtime; end
  def event_already_finished?; event_finish_time_with_default <= Time.now.localtime; end
  def event_now_in_progress?; event_already_started? && (!(event_already_finished?)); end
  def event_still_actual?; (!event_already_finished?); end



  def can_owner_attach_image?; can_owner_edit_this_event? && (valid_event_imgs.count < user.event_max_images_cnt); end
  def logo_img_html; "<img class='event_logo_img' src='#{ get_sm_logo_path }'>".html_safe; end
  def get_sm_logo_path; valid_event_imgs.any? ? valid_event_imgs.first.image_sm_url : NO_LOGO_IMG_PATH; end
  def get_logo_or_nil; valid_event_imgs.any? ? valid_event_imgs.first.image_file : nil; end
  def valid_event_imgs; event_imgs.select(&:image_valid?); end

  def event_was_published?; visibility_status_id.positive?; end


  def logo_img_index; 0; end

  def have_tickets_for_sale?
    result = false
    event_ticket_packs.each do |tpack|
      result = true if tpack.can_sold_at_least_one_ticket_theoretically?
    end
    result
  end

  def recalc_not_payed_slots_cnt!
    new_not_payed_slots_cnt = 0
    event_ticket_packs.each do |tpack|
      new_not_payed_slots_cnt += tpack.get_tickets_that_can_sold_theoretically_cnt
    end
    unless new_not_payed_slots_cnt.eql?(not_payed_slots_cnt)
      update!(not_payed_slots_cnt: new_not_payed_slots_cnt)
    end
    true
  end

  def event_start_time_is_possible?
    if event_start_time_changed?
      if event_start_time.nil? || event_start_time.blank?
        errors.add(:event_start_time, "can not be null")
      else
        if event_finish_time
          unless event_start_time < event_finish_time
            errors.add(:event_start_time, "must be less than finish time")
          end
        end
      end
    end

    if event_finish_time_changed?
      if event_finish_time.nil? || event_finish_time.blank?
        errors.add(:event_finish_time, "can not be null")
      else
        if event_finish_time > Time.now().localtime
          if event_start_time
            unless event_start_time < event_finish_time
              errors.add(:event_finish_time, "must be more than start time")
            end
          end
        else
          errors.add(:event_finish_time, "must be from future")
        end
      end
    end
  end

  def visibility_status_possible?
    if visibility_status_changed?
      if visibility_status_published?
        if event_start_time

        else
          errors.add(:event_start_time, "choose start time")
        end
        if event_finish_time
          if (event_finish_time > event_start_time)
            errors.add(:event_finish_time, "from the past") unless (event_finish_time >= Time.now().localtime)
          else
            errors.add(:event_finish_time, "not valid")
          end
        else
          errors.add(:event_finish_time, "choose finish time")
        end
      end
    end
  end

  def refill_search_text
    text = "#{ name } #{ description } #{ house_rules } #{ address }".gsub('->', ' ').gsub(/[\.\,\t\n\r\'\"\`\(\)\+\=\~\\]+/, ' ').downcase

    uniq_words = text.split(' ').uniq.sort
    write_attribute :search_text, uniq_words.join(' ')
    true
  end

  def refill_event_rang_pts
    new_event_rang_pts = get_logo_or_nil ? 200 : 0
    new_event_rang_pts += (10 * visibility_status_id)
    new_event_rang_pts += (20 * rating)
    write_attribute :event_rang_pts, new_event_rang_pts
    true
  end

  def refill_event_props
    old_props = event_props.sort_by(&:pos_id)
    new_props = ["E->Rating->#{ rating }"]
    new_props += house_rules.to_s.split_to_props_arr.uniq
    new_num = 0
    new_props.each do |new_prop|
      new_item = old_props.fetch(new_num) { |i| EventProp.new(event_id: id) }
      new_item.assign_attributes({ pos_id: new_num, name: new_prop.strip_prop })
      if new_item.valid? && new_item.changed_attributes.any?
        unless new_item.save
          raise("ERROR 23213212312. errors=[#{ new_item.errors.inspect }]")
        end
      end
      new_num += 1
    end
    old_props.each_with_index { |old_item, i| old_item.destroy! if (i >= new_num) }
    true
  end

  def recalc_event_rating!
    new_rating = 0.0
    update!(rating: new_rating) unless new_rating.eql?(event_rating.to_f)
  end

  def availability_html
    av_name = visibility_status
    if event_already_finished?
      av_name = "Event finished"
    else
      av_name = "No tickets!" unless have_tickets_for_sale?
    end
    "<span class='visibility_status_span'>#{ av_name.to_s.ehtml }</span>".html_safe
  end

  def attendance?(user_id)
    tickets.successfully_payed.where(user_id: user_id).exists?
  end
end
