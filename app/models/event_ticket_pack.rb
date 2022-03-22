# frozen_string_literal: true

class EventTicketPack < ApplicationRecord
  belongs_to :event
  has_many :tickets

  validates :event, presence: true
  validates :name, length: { minimum: 0, maximum: 200 }, allow_blank: true
  validates :pack_capacity, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000000, only_integer: true }
  validates :ticket_cost_eur, presence: true, numericality: { greater_than_or_equal_to: 0.51, less_than_or_equal_to: 1000000 }


  scope :by_events, ->(events_scope) { where(event: events_scope) }
  after_save :event_recalc_not_payed_slots_cnt

  def event_ticket_collection_type_id; self.class.event_ticket_pack_types[event_ticket_pack_type]; end
  enum event_ticket_pack_type: { guest: 0, vip: 10, resident: 20 }

  def event_ticket_pack_sale_rule_id; self.class.event_ticket_pack_sale_rules[event_ticket_pack_sale_rule]; end
  enum event_ticket_pack_sale_rule: { stopped_sale: 0, simple_sale: 1, with_confirmation: 2,
                                      with_confirmation_after_start: 3, simple_sale_to_start_only: 4 }, _prefix: true

  # def created_at_unixtime; created_at.nil? ? nil : created_at.to_time.to_i; end
  # def user_name; user.present? ? user.name : super; end


  # def refresh_order_status_if_need
    # event.recalc_event_rating!
  # end

  def event_recalc_not_payed_slots_cnt; event.recalc_not_payed_slots_cnt!; end
  def tickets_payment_in_process_cnt; tickets_slotted_cnt - tickets_sold_cnt; end
  def ticket_cost_eur_cts; (ticket_cost_eur * 100).round(0).to_i; end
  def tpack_calc_one_ticket_payout_for_owner_eur_cts; (ticket_cost_eur * 98).round(0).to_i; end
  def ticket_slot_need_confirmation?
    return true if event_ticket_pack_sale_rule_with_confirmation?
    if event.event_already_started?
      return true if event_ticket_pack_sale_rule_simple_sale_to_start_only?
    end
    false
  end

  def recalc_tickets_sold_cnt!
    new_sold_cnt = tickets.successfully_payed.count
    update!(tickets_sold_cnt: new_sold_cnt) unless tickets_sold_cnt.eql?(new_sold_cnt)
    true
  end

  def release_ticket_slot!
    sql = "UPDATE event_ticket_packs SET tickets_slotted_cnt=tickets_slotted_cnt-1
            WHERE ((id=#{ id }) AND (tickets_slotted_cnt>0))"
    sql_affected = ActiveRecord::Base.connection.update(sql)
    if (sql_affected || 0).positive?
      reload
      return true
    end
    false
  end

  def unsafe_inc_tickets_slotted_cnt!(cnt = 1)
    unless cnt.zero?
      sql = "UPDATE event_ticket_packs SET tickets_slotted_cnt=(tickets_slotted_cnt+(#{ cnt })) WHERE (id=#{ id })"
      sql_affected = ActiveRecord::Base.connection.update(sql)
      if (sql_affected || 0).positive?
        reload
      else
        raise("ERROR 453554433453")
      end
    end
    true
  end

  def success_placed_ticket_slot_in_tpack_by_sqls?
    return false unless id.positive? && tpack_can_try_give_a_slot?
    sql = "UPDATE event_ticket_packs SET tickets_slotted_cnt=tickets_slotted_cnt+1
            WHERE ((id=#{ id }) AND (pack_capacity>tickets_slotted_cnt))"
    sql_affected = ActiveRecord::Base.connection.update(sql)
    # puts "\n\n\n sql_affected=[#{ sql_affected }] sql=[#{ sql }] \n\n\n"
    if (sql_affected || 0).positive?
      reload
      return true
    end
    false
  end

  def tpack_can_try_give_a_slot?
    return false unless event.event_still_actual?
    return false unless event.visibility_status_published?
    return false unless event_ticket_pack_sale_rule_id.positive?
    pack_capacity > tickets_slotted_cnt
  end

  def can_sold_at_least_one_ticket_theoretically?; get_tickets_that_can_sold_theoretically_cnt.positive?; end
  def get_tickets_that_can_sold_theoretically_cnt
    result = 0
    return result unless event_ticket_pack_sale_rule_id.positive?
    return result if event.event_already_finished?
    if event.event_already_started?
      return result if event_ticket_pack_sale_rule_simple_sale_to_start_only?
    end
    pack_capacity - tickets.successfully_payed.count
  end



end
