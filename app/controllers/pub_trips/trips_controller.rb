# frozen_string_literal: true

class ::PubTrips::TripsController < ::PubTrips::PubTripsBaseController
  skip_before_action :set_front_side_current_trip, only: %w{index new create}


  def index
    add_breadcrumb "Trips", :trips_path
    per_page = 24
    events_data = ::PubPartiesSearchHelper.get_events_collection(params)
    events = events_data[:events]
    search_item = { name: 'Search', prop_name: :search }
    @filter_items = [search_item] + events_data[:filter_items]
    @items = events.page(params_page).per(per_page)
  end

  def show
    @item = @front_side_current_trip
  end
end
