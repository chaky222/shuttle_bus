class Profile::MyEvents::MyEventsBaseController < FrontProfileController
  add_breadcrumb "My events", :profile_my_events_path
  before_action :set_current_my_event

  def set_current_my_event
    return @current_my_event if @current_my_event
    id = params[:my_event_id] || params[:my_event_my_event_id]
    result = current_user.events.detect { |x| x.id.eql?(id.to_i || 0) }
    unless result
      raise ActionController::RoutingError.new("Event #{ id } not found in your profile")
    end
    add_breadcrumb "Event \##{ result.id }", result.profile_default_url
    @current_my_event = result
    result
  end

  helper_method :my_event_tpack_item_row_html
  def my_event_tpack_item_row_html(tpack)
    render_to_string(partial: "/profile/my_events/my_events/my_event_tpack_row", :locals => { tpack: tpack })
  end

end
