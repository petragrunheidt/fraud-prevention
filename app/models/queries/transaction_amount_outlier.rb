module Queries
  class TransactionAmountOutlier
    def initialize(current_transaction_amount)
      @current_transaction_amount = current_transaction_amount
    end

    def self.outlier?(current_transaction_amount)
      new(current_transaction_amount).outlier?
    end

    def outlier?
      stats = calculate_current_stats
      return false if stats.values.any?(&:nil?)

      z = z_score(
        current_transaction_amount,
        stats[:mean],
        stats[:std_deviation]
      )

      z.abs > 3
    end

    private

    attr_reader :current_transaction_amount

    def z_score(value, mean, std_deviation)
      (value - mean) / std_deviation
    end

    def calculate_current_stats
      mean, std_deviation = Transaction.pick(
        "AVG(transaction_amount) AS mean,
         STDDEV_POP(transaction_amount) AS std_deviation"
      )

      { mean:, std_deviation: }
    end
  end
end
