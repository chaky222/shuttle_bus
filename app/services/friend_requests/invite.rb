# frozen_string_literal: true

module FriendRequests
  class Invite
    prepend BasicService

    option :requestor, model: User
    option :receiver, model: User

    def call
      return fail_t!(:you_are_already_friends) if requestor.friend?(receiver)

      requestor.friend_requests_as_requestor.create!(receiver: receiver)
    end

    private

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.friend_requests.invite'))
    end
  end
end
