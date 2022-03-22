# frozen_string_literal: true

module Reports
  class Create
    prepend BasicService

    option :reporter_id
    option :event_id
    option :kind
    option :reason
    option :reported_users_attributes, optional: true
    option :description, optional: true

    attr_reader :report

    def call
      @report = new_report

      fail!(report.errors.messages) unless report.save

      notify_host! if success?
    end

    private

    def new_report
      Report.new(report_params)
    end

    def report_params
      {
        reporter_id: reporter_id,
        event_id: event_id,
        kind: kind,
        reason: reason,
        reported_users_attributes: reported_users_attributes,
        description: description
      }
    end

    # TODO
    def notify_host!
      true
    end
  end
end
