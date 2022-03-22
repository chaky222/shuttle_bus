# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  belongs_to :requestor, class_name: :User, inverse_of: :friend_requests_as_requestor
  belongs_to :receiver, class_name: :User, inverse_of: :friend_requests_as_receiver

  validates :requestor_id, uniqueness: { scope: :receiver_id }
  validate :friend_to_himself!

  private

  def friend_to_himself!
    errors.add(:receiver, :friend_to_himself) if requestor_id == receiver_id
  end
end
