# frozen_string_literal: true

class ::PubTrips::PubTripsBaseController < ::PagesController
  add_breadcrumb "Trips", :trips_path
  before_action :set_front_side_current_trip

  def set_front_side_current_trip
    return @front_side_current_trip if @front_side_current_trip
    id = params[:tr_id] || params[:pub_trips_tr_id]
    result = Trip.find(Integer(id))
    unless result
      raise ActionController::RoutingError.new("Trip #{ id } not found")
    end
    main_data[:title] = "Trip \##{ result.id }"
    add_breadcrumb main_data[:title], trip_path(result.id)
    @front_side_current_trip = result
    result
  end
end
