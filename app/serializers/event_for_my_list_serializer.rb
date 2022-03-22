class EventForMyListSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :house_rules, :address, :latitude, :longitude,
              :event_start_time_unixtime, :event_finish_time_unixtime,
              :place_square_meters,
              :declined_at_unixtime, :created_at_unixtime

end