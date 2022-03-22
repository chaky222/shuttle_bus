# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :event_ticket_pack
  belongs_to :user
  has_many :tickets_payments
  # has_one :event,  through: :event_ticket_pack

  scope :successfully_payed, ->() { where.not(ticket_payed_at: nil) }

  scope :for_event, ->(event) { where(event_ticket_pack: event.event_ticket_packs) }
  scope :for_events_scope, ->(events_scope) { where(event_ticket_pack: EventTicketPack.by_events(events_scope)) }

  def ticket_status_id; self.class.ticket_statuses[ticket_status]; end
  enum ticket_status: { created: 0, slot_fail: 1, slot_canceled: 3, slot_declined: 5, slot_asked: 8, slot_accepted: 10,
                        # payment_fail: 15,
                        slot_taked: 20,
                        # payment_in_progress: 25,
                        # payment_checking: 35,
                        # payed: 40,
                        # used: 50
                      }, _prefix: true

  def accepted_not_refuneded_payments; tickets_payments.select { |x| x.amount_accepted_cts.positive? && x.amount_refunded_cts.zero? }; end
  def ticket_refund_sum_cts; tickets_payments.reduce(0) { |r, x| r += x.amount_refunded_cts }; end
  def ticket_accepted_sum_cts; tickets_payments.reduce(0) { |r, x| r += x.amount_accepted_cts }; end
  def ticket_payed_sum_cts; ticket_accepted_sum_cts - ticket_refund_sum_cts; end
  def ticket_fully_payed?; ticket_payed_sum_cts >= cost_eur_cts; end
  def ticket_can_be_refunded?; accepted_not_refuneded_payments.any?; end

  def current_ticket_cost_eur; (cost_eur_cts / 100.0); end
  def current_ticket_for_owner_eur; (for_owner_eur_cts / 100.0); end

  def ticket_need_slotting?
    unless ticket_fully_payed?
      if event_ticket_pack.event_ticket_pack_sale_rule_with_confirmation?
        if ticket_status.in? %w{slot_accepted}
          return true
        end
      else
        if ticket_status.in? %w{created slot_canceled slot_declined slot_asked slot_accepted}
          return true
        end
      end
    end
    false
  end

  def ticket_need_payment?
    unless ticket_fully_payed?
      if event_ticket_pack.event_ticket_pack_sale_rule_with_confirmation?
        if ticket_status.in? %w{slot_accepted slot_taked}
          return true
        end
      else
        if ticket_status.in? %w{created slot_canceled slot_declined slot_asked slot_accepted slot_taked}
          return true
        end
      end
    end
    false
  end

  def can_user_try_to_pay_ticket?
    unless ticket_fully_payed?
      return false if tickets_payments.find { |x| x.payment_transaction_in_progress? }
      if event_ticket_pack.event_ticket_pack_sale_rule_with_confirmation?
        if ticket_status.in? %w{slot_accepted slot_taked}
          return true
        end
      else
        if ticket_status.in? %w{created slot_canceled slot_declined slot_asked slot_accepted slot_taked}
          return true
        end
      end
    end
    false
  end

  def ticket_payment_fail?
    unless ticket_fully_payed?
      return true if tickets_payments.any? && (!(tickets_payments.select { |x| x.payment_transaction_in_progress? }))
    end
    false
  end

  def ticket_allow_user_to_see_chat?; ticket_fully_payed?; end
  def ticket_payment_refunded?; tickets_payments.find { |x| x.amount_refunded_cts.positive? } ? true : false; end

  def try_take_slot_in_tpack!
    if id.positive? && event_ticket_pack.id.positive?
      return true if ticket_status_slot_taked?
      if event_ticket_pack.tpack_can_try_give_a_slot?
        can_try_get_slot = false
        if ticket_status_created?
          if event_ticket_pack.event_ticket_pack_sale_rule_with_confirmation?
            update!(ticket_status: :slot_asked)
            return false
          else
            can_try_get_slot = true
          end
        elsif ticket_status_slot_canceled?
          can_try_get_slot = true
        elsif ticket_status_slot_accepted?
          can_try_get_slot = true
        end
        if can_try_get_slot
          if event_ticket_pack.success_placed_ticket_slot_in_tpack_by_sqls?
            update!(ticket_status: :slot_taked)
            return true
          else
            update!(ticket_status: :slot_fail)
          end
        end
      end
    end
    false
  end

  def client_ticket_name_html; "<span class='ticket_name'>Ticket \##{ id.to_s }</span>".html_safe; end
  def client_ticket_status_html
    s = { n: ticket_status.to_s, s: 'color: black' }
    s = { n: "Ticket payed!", s: 'color: green' } if ticket_fully_payed?
    s = { n: "Ticket need payments", s: 'color: orange' } if ticket_need_payment?
    s = { n: "Ticket payment fail", s: 'color: red' } if ticket_payment_fail?
    s = { n: "Ticket payment refunded", s: 'color: red' } if ticket_payment_refunded?
    "<span class='ticket_status' style='#{ s[:s].ehtml };'>#{ s[:n].ehtml }</span>".html_safe
  end

  def refill_payed_at!
    have_changes = false
    if accepted_not_refuneded_payments.any?
      unless ticket_payed_at
        update!(ticket_payed_at: accepted_not_refuneded_payments.last.updated_at)
        have_changes = true
      end
    else
      if ticket_payed_at
        update!(ticket_payed_at: nil)
        have_changes = true
      end
    end
    event_ticket_pack.recalc_tickets_sold_cnt! if have_changes
    true
  end

end
