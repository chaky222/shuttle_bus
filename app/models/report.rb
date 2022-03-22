# frozen_string_literal: true

class Report < ApplicationRecord
  EVENT_REASONS = ['custom', 'wrong_criteria', 'something_has_been_broken'].freeze
  USER_REASONS = [
    'custom', 'sexual_abuse', 'illegal_behavior', 'inappropriate_behavior', 'fake_account', 'non_respect_of_the_rules'
  ].freeze

  belongs_to :reporter, class_name: :User, foreign_key: :reporter_id, inverse_of: :reports
  belongs_to :event, inverse_of: :reports
  belongs_to :admin_user, class_name: :AdminUser, inverse_of: :reports, optional: true
  has_many :reported_users, dependent: :destroy, inverse_of: :report
  has_many :users, through: :reported_users

  validates :reporter_id, :event_id, :kind, :reason, presence: true
  validates :description, presence: true, if: :reason_custom?
  validates :reported_users, presence: true, if: :kind_user?
  validates :reason, inclusion: { in: USER_REASONS }, if: :kind_user?
  validates :reason, inclusion: { in: EVENT_REASONS }, if: :kind_event?
  validate :reported_users_existanse, if: :kind_event?
  validate :reporter_attendance

  accepts_nested_attributes_for :reported_users

  enum kind: {
    event: 0,
    user: 1
  }, _prefix: true

  enum reason: {
    custom: 0,
    sexual_abuse: 1,
    illegal_behavior: 2,
    inappropriate_behavior: 3,
    fake_account: 4,
    non_respect_of_the_rules: 5,
    wrong_criteria: 100,
    something_has_been_broken: 101
  }, _prefix: true

  enum status: {
    waiting: 0,
    processing: 1,
    finished: 100
  }, _prefix: true

  private

  def reported_users_existanse
    errors.add(:reported_users, :reported_users_exist) if reported_users.present?
  end

  def reporter_attendance
    errors.add(:reporter, :attendance_mistake) unless reporter_attendance?
  end

  def reporter_attendance?
    event.attendance?(reporter_id)
  end
end
