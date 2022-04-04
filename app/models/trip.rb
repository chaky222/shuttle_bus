# frozen_string_literal: true

class Trip < ApplicationRecord
  NO_LOGO_IMG_PATH = '/pics/no_image.png'.freeze

  belongs_to :vehicle
  belongs_to :user_route
  has_many :trip_chat_msgs, dependent: :destroy
  scope :active        , -> { where(deleted_at: nil) }
  scope :published_only, -> { where(published: 1) }


  validates :starts_at_unix, numericality: { greater_than_or_equal_to: 1, only_integer: true }, presence: true
  validates :all_trip_tickets_cnt, numericality: { greater_than_or_equal_to: 0, only_integer: true }, presence: true
  validate :validate_same_user_route_and_vehicle

  def validate_same_user_route_and_vehicle
    if errors.empty? && vehicle && user_route
      unless user_route.user_id.eql?(vehicle.user_id)
        errors.add(:vehicle, 'User should be same')
      end
    end
  end

  def trip_start_time_unix_with_default; starts_at_unix.positive? ? starts_at_unix : (Time.now + 2.hours).to_i; end
  def trip_start_time; Time.at(starts_at_unix).to_datetime.localtime; end
  def trip_start_time_with_default; Time.at(trip_start_time_unix_with_default).to_datetime.localtime; end
  def trip_published?; published.positive?; end
  def client_trip_name_html; "<span class='client_trip_name_span'>Trip \##{ id }</span>".html_safe; end

  def trip_have_tickets_for_sale?; all_trip_tickets_cnt.positive?; end

  def trip_users_with_ticket; []; end

  def publish_status_html
    "<div class='trip_publish_status' published='#{ published }'>
      Publish status: <span>#{ trip_published? ? 'Published' : 'Not_published' }</span>
    </div>".html_safe
  end
end
