# frozen_string_literal: true

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :assessable_type, :rating, :comment, :reason

  belongs_to :assessable

  class << self
    def serializer_for(model, options)
      case model.class.to_s
      when 'User'
        UserMinSerializer
      when 'Event'
        EventForSearchListSerializer
      end
    end
  end
end
