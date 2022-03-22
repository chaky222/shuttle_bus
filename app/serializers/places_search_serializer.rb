# frozen_string_literal: true

class PlacesSearchSerializer < ActiveModel::Serializer
  attributes :display_name, :latitude, :longitude, :country, :city, :state, :street, :house_number

  def display_name
    data['display_name']
  end

  def latitude
    data['lat']
  end

  def longitude
    data['lon']
  end

  def country
    address.dig('country')
  end

  def city
    address.dig('city')
  end

  def state
    address.dig('state')
  end

  def street
    address.dig('street') || address.dig('road')
  end

  def house_number
    address.dig('house_number')
  end

  private

  def data
    object.data
  end

  def address
    data.dig('address')
  end
end
