# frozen_string_literal: true

class PartiesModule::PartiesBaseController < ::PagesController
  add_breadcrumb "Parties", :parties_path
  before_action :set_front_side_current_party

  def set_front_side_current_party
    return @front_side_current_party if @front_side_current_party
    id = params[:party_id] || params[:party_party_id]
    result = Event.find(Integer(id))
    unless result
      raise ActionController::RoutingError.new("Event #{ id } not found")
    end
    main_data[:title] = "Party \##{ result.id }"
    add_breadcrumb main_data[:title], result.client_default_url
    @front_side_current_party = result
    result
  end

  helper_method :can_current_user_read_party_chat?
  def can_current_user_read_party_chat?
    return false unless current_user && @front_side_current_party
    result = false
    current_user.tickets.where(event_ticket_pack: @front_side_current_party.event_ticket_packs).each do |event_ticket|
      result = true if event_ticket.ticket_allow_user_to_see_chat?
    end
    result
  end
end
