module Queries
  class RecentUserTransaction
    def initialize(user_id, transaction_date)
      @user_id = user_id
      @transaction_date = transaction_date
    end

    def self.time_since_last_transaction(user_id:, transaction_date:)
      new(user_id, transaction_date).time_since_last_transaction
    end

    def time_since_last_transaction
      latest_transaction_date && transaction_date - latest_transaction_date
    end

    private

    attr_reader :user_id, :transaction_date

    def latest_transaction_date
      Transaction.where(user_id: user_id)
      .order(transaction_date: :desc)
      .limit(1)
      .pluck(:transaction_date)
      .first
    end
  end
end