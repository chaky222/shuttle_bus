# frozen_string_literal: true

class Review < ApplicationRecord
  BASE_REASONS = ['base'].freeze
  USER_REASONS = ['didnt_get_along_well', 'inappropriate_or_dangerous_behavior'].freeze

  belongs_to :reviewer, class_name: :User, inverse_of: :reviews_as_reviewer
  belongs_to :assessable, polymorphic: true

  enum reason: {
    base: 0,
    didnt_get_along_well: 1,
    inappropriate_or_dangerous_behavior: 2
  }, _prefix: true

  validates :reviewer, :assessable, :rating, presence: true
  validates :reason, presence: true, inclusion: { in: USER_REASONS }, if: ->(r) {
    (r.dislike? && r.on_user?)
  }

  validate :review_to_himself!, if: :on_user?
  validate :reviewer_attendance!, if: :on_event?

  def dislike?
    rating.to_f < 3
  end

  def on_user?
    assessable_type == 'User'
  end

  def on_event?
    assessable_type == 'Event'
  end

  private

  def review_to_himself!
    errors.add(:assessable, :review_to_himself) if reviewer_id == assessable_id
  end

  def reviewer_attendance!
    errors.add(:reviewer, :attendance_mistake) unless assessable.attendance?(reviewer_id)
  end
end
