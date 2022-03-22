# frozen_string_literal: true

module Reviews
  class Create
    prepend BasicService

    option :reviewer_id
    option :assessable_id
    option :assessable_type
    option :rating
    option :comment, optional: true
    option :reason, optional: true

    attr_reader :review

    def call
      @review = Review.new(review_params)

      fail!(review.errors.messages) unless review.save
    end

    private

    def review_params
      {
        reviewer_id: reviewer_id,
        assessable_id: assessable_id,
        assessable_type: assessable_type,
        rating: rating,
        comment: comment,
        reason: reason
      }
    end
  end
end
