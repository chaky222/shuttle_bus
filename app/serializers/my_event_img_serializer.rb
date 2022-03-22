# frozen_string_literal: true

class MyEventImgSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :image_sm_url, :image_full_url, :prio,
  :created_at_unixtime, :updated_at_unixtime


end
