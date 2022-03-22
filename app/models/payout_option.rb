# frozen_string_literal: true

class PayoutOption < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :bank_code_name, length: { in: 2..30 }, presence: true
  validates :bank_account_number, length: { in: 2..60 }, presence: true

  def payout_name_for_client
    "Bank #{ bank_code_name }, account: #{ bank_account_number }"
  end
end

