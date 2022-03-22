# frozen_string_literal: true

module Reports
  class Close
    prepend BasicService

    FINISHED_STATUS = 'finished'

    option :report

    def call
      report.status = FINISHED_STATUS

      fail!(report.errors.messages) unless report.save
    end
  end
end
