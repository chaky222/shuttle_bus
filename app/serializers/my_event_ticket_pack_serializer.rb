# frozen_string_literal: true

class MyEventTicketPackSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :pack_capacity, :tickets_slotted_cnt, :tickets_sold_cnt, :tickets_pay_fail_cnt,
  :ticket_cost_eur, :event_ticket_pack_type, :event_ticket_pack_sale_rule,
  :created_at_unixtime, :updated_at_unixtime


end
