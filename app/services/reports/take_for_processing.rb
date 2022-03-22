# frozen_string_literal: true

module Reports
  class TakeForProcessing
    prepend BasicService

    PROCESSING_STATUS = 'processing'

    option :report
    option :admin_user

    def call
      report.status = PROCESSING_STATUS
      report.admin_user = admin_user
      report.take_for_processing_at = Time.zone.now

      fail!(report.errors.messages) unless report.save
    end
  end
end
