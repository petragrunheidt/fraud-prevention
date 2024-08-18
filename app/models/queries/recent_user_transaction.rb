module Queries
  class RecentUserTransaction
    DEFAULT_RECENT_THRESHOLD = 12.hours

    private_constant :DEFAULT_RECENT_THRESHOLD

    def initialize(
      user_id,
      transaction_date,
      recent_threshold = DEFAULT_RECENT_THRESHOLD
    )
      @user_id = user_id
      @transaction_date = transaction_date
      @recent_threshold = recent_threshold
    end

    attr_reader :user_id, :transaction_date, :recent_threshold

    def self.recent_transactions_count(
      user_id:,
      transaction_date:,
      recent_threshold: DEFAULT_RECENT_THRESHOLD
    )
      new(user_id, transaction_date, recent_threshold).recent_transactions_count
    end

    def recent_transactions_count
      @recent_transaction_count ||= calculate_recent_transactions_count
    end

    private

    def calculate_recent_transactions_count
      Transaction.where(
        user_id: @user_id,
        transaction_date: @transaction_date.ago(@recent_threshold)..@transaction_date
      ).count
    end
  end
end
