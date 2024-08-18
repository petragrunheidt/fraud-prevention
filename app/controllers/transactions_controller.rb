class TransactionsController < ApplicationController
  FRAUD_SCORE_THRESHOLD = 60.0
  DENIED_RESPONSE = { recommendation: 'deny' }.freeze
  APPROVED_RESPONSE = ->(transaction_id) { { transaction_id:, recommendation: 'approve' } }

  private_constant :FRAUD_SCORE_THRESHOLD

  def create
    transaction = Transaction.new(transaction_params)
    is_fraud = flag_fraud?(transaction)

    return render json: DENIED_RESPONSE, status: :ok if is_fraud
    return :unprocessable_entity unless transaction.save!

    render json: APPROVED_RESPONSE.call(transaction.transaction_id), status: :ok
  end

  private

  def flag_fraud?(transaction)
    return true if Services::FraudBlock.should_block?(transaction)

    Services::FraudScore.fraud_score(transaction) > FRAUD_SCORE_THRESHOLD
  end

  def transaction_response(transaction)

  end

  def transaction_params
    params
      .require(:transaction)
      .permit(
        :merchant_id,
        :user_id,
        :card_number,
        :transaction_amount,
        :device_id
      ).merge({
        transaction_date: Time.zone.now,
        has_cbk: false
      })
  end
end
