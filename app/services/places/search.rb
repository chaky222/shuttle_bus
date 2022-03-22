# frozen_string_literal: true

module Places
  class Search
    prepend BasicService

    option :query
    attr_reader :places

    def call
      @places = Geocoder.search(query)
    end
  end
end
