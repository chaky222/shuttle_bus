class PayoutOptionSerializer < ActiveModel::Serializer
  attributes :id, :bank_code_name, :bank_account_number, :created_at
  # has_one :profile, serializer: ProfileSerializer
end
