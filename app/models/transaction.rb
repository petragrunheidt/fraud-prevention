class Transaction < ApplicationRecord
  validates :transaction_amount,
            :transaction_date,
            :user_id,
            :merchant_id,
            :card_number,
            presence: true
end
