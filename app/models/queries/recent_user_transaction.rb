module Queries
  class RecentUserTransaction
    DEFAULT_RECENT_THRESHOLD = 12.hours
    def initialize(
      user_id,
      transaction_date,
      recent_threshold = DEFAULT_RECENT_THRESHOLD
    )
      @user_id = user_id
      @transaction_date = transaction_date
      @recent_threshold = recent_threshold
    end

    def self.time_since_last_transaction(user_id:, transaction_date:)
      new(user_id, transaction_date).time_since_last_transaction
    end

    def time_since_last_transaction
      latest_transaction_date && (transaction_date - latest_transaction_date)
    end

    def self.recent_transactions_count(
      user_id:,
      transaction_date:,
      recent_threshold: DEFAULT_RECENT_THRESHOLD
    )
      new(user_id, transaction_date, recent_threshold).recent_transactions_count
    end

    def recent_transactions_count
      Transaction.where(
        user_id:,
        transaction_date: transaction_date.ago(recent_threshold)..transaction_date
      ).count
    end

    private

    attr_reader :user_id, :transaction_date, :recent_threshold

    def latest_transaction_date
      Transaction.where(user_id:)
                 .order(transaction_date: :desc)
                 .limit(1)
                 .pluck(:transaction_date)
                 .first
    end
  end
end
