# frozen_string_literal: true

module Users
  class SelectFriendUsersIdsQuery
    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.connection.execute(select_sql).to_a.flatten
    end

    private

    attr_reader :user

    def select_sql
      <<~SQL
        SELECT out_request.receiver_id from friend_requests as out_request
        INNER JOIN friend_requests inner_request ON out_request.receiver_id = inner_request.requestor_id
        WHERE out_request.requestor_id = #{user.id} AND inner_request.receiver_id = #{user.id}
      SQL
    end
  end
end
