# frozen_string_literal: true

module Events
  class Nearby
    prepend BasicService

    option :api_user
    option :latitude
    option :longitude
    option :radius, default: -> { 40 }
    attr_reader :events

    def call
      @events = Event.published.near([latitude, longitude], radius).includes(:event_imgs)
    end
  end
end
