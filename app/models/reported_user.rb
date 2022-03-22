# frozen_string_literal: true

class ReportedUser < ApplicationRecord
  belongs_to :report
  belongs_to :user

  validates :report_id, uniqueness: { scope: :user_id }
  validate :user_attendance

  def user_attendance
    errors.add(:user, :attendance_mistake) unless user_attendance?
  end

  def user_attendance?
    report.event.attendance?(user_id)
  end
end
