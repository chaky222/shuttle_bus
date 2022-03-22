# frozen_string_literal: true

class PartiesModule::BuyTicketModule::BuyTicketBaseController < ::PartiesModule::PartiesBaseController
  before_action :set_front_side_tickets_pack

  def set_front_side_tickets_pack
    return @front_side_tickets_pack if @front_side_tickets_pack
    add_breadcrumb "Tickets", party_tickets_path(@front_side_current_party.id)
    id = params[:tpack_id] || params[:tpack_tpack_id]
    result = @front_side_current_party.event_ticket_packs.find(Integer(id))
    unless result
      raise ActionController::RoutingError.new("TicketsPack #{ id } not found")
    end
    add_breadcrumb "TicketPack \##{ result.id }", party_ticket_path(@front_side_current_party.id, result.id)
    @front_side_tickets_pack = result
    result
  end
end
