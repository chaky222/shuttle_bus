# frozen_string_literal: true

module Users
  class CheckFriendshipQuery
    def initialize(user)
      @initial_user = user
    end

    def friend?(user)
      FriendRequest.where(requestor_id: initial_user.id, receiver_id: user.id).exists? &&
        FriendRequest.where(requestor_id: user.id, receiver_id: initial_user.id).exists?
    end

    private

    attr_reader :initial_user
  end
end
