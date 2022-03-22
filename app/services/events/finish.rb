# frozen_string_literal: true

module Events
  class Finish
    prepend BasicService

    FINISHED_STATUS = 'finished'

    option :event, model: Event

    def call
      event.visibility_status = FINISHED_STATUS

      fail!(event.errors.messages) unless event.save
    end
  end
end
