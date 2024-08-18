module Services
  class FraudBlock
    RECENT_RULE_THRESHOLD = 12.hours
    HIGH_TRANSACTION_AMOUNT = 300.0

    private_constant :RECENT_RULE_THRESHOLD, :HIGH_TRANSACTION_AMOUNT

    def initialize(transaction)
      @transaction = transaction
    end

    def self.should_block?(transaction)
      new(transaction).should_block?
    end

    def should_block?
      [
        recent_transaction_rule,
        previous_user_fraud_rule
      ].any?
    end

    private

    attr_reader :transaction

    def recent_transaction_rule
      count = recent_transactions_count
      return false if count < 3
      return true if count >= 5

      transaction.transaction_amount > HIGH_TRANSACTION_AMOUNT
    end

    def recent_transactions_count
      Queries::RecentUserTransaction.recent_transactions_count(
        user_id: transaction.user_id,
        transaction_date: transaction.transaction_date,
        recent_threshold: RECENT_RULE_THRESHOLD
      )
    end

    def previous_user_fraud_rule
      Transaction.where(user_id: transaction.user_id, has_cbk: true).exists?
    end
  end
end
