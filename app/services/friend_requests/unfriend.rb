# frozen_string_literal: true

module FriendRequests
  class Unfriend
    prepend BasicService

    option :rejecter, model: User
    option :rejected, model: User

    def call
      return fail_t!(:you_are_not_friends) unless rejecter.friend?(rejected)

      FriendRequest.where(
        sql_query,
        rejecter_id: rejecter.id, rejected_id: rejected.id
      ).destroy_all
    end

    private

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.friend_requests.unfriend'))
    end

    def sql_query
      '(requestor_id = :rejecter_id AND receiver_id = :rejected_id) OR ' \
        '(requestor_id = :rejected_id AND receiver_id = :rejecter_id)'
    end
  end
end
