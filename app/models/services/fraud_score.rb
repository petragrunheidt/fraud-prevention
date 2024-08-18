module Services
  class FraudScore
    ONE_DAY = 1.day.to_i
    OUTLIER_TRANSACTION_AMOUNT_SCORE = 35.0
    RECENT_TRANSACTION_SCORE = 5.0
    PREVIOUS_FRAUD_SCORE = 55.0

    private_constant :OUTLIER_TRANSACTION_AMOUNT_SCORE,
                     :RECENT_TRANSACTION_SCORE,
                     :PREVIOUS_FRAUD_SCORE

    def initialize(transaction)
      @transaction = transaction
    end

    def self.fraud_score(transaction)
      new(transaction).fraud_score
    end

    def fraud_score
      [
        outlier_transaction_amount_score,
        recent_transaction_score,
        previous_frauds_score
      ].sum
    end

    private

    attr_reader :transaction

    def outlier_transaction_amount_score
      is_outlier = Queries::TransactionAmountOutlier.outlier?(transaction.transaction_amount)
      is_outlier ? OUTLIER_TRANSACTION_AMOUNT_SCORE : 0
    end

    def recent_transaction_score
      recent_transactions_count = Queries::RecentUserTransaction
                                  .recent_transactions_count(
                                    user_id: transaction.user_id,
                                    transaction_date: transaction.transaction_date
                                  )

      recent_transactions_count * RECENT_TRANSACTION_SCORE
    end

    def previous_frauds_score
      percentage = Queries::PreviousFraudPercentage.normalized_percentage(
        transaction.device_id,
        transaction.merchant_id
      )

      case percentage
      when 0.0..0.2 then 0
      when 0.2..0.5 then PREVIOUS_FRAUD_SCORE / 2
      else PREVIOUS_FRAUD_SCORE
      end
    end
  end
end
