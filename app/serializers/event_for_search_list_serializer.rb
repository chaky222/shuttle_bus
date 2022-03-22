class EventForSearchListSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :house_rules, :address, :latitude, :longitude,
              :event_start_time_unixtime, :event_finish_time_unixtime,
              :place_square_meters, :sm_images_urls,
              :event_rang_pts, :declined_at_unixtime, :created_at_unixtime

  def sm_images_urls; object.event_imgs.map(&:image_sm_url); end
 end