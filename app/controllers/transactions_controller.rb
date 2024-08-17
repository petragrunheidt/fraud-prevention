class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    is_fraud = flag_fraud?(transaction)
    transaction.has_cbk = is_fraud

    return :unprocessable_entity unless transaction.save!

    response = { transaction_id: transaction.transaction_id,
                 recommendation: recommendation(is_fraud) }

    render json: response, status: :ok
  end

  private

  def flag_fraud?(transaction)
    fraud_score = Services::FraudScore.fraud_score(transaction)

    fraud_score > 15
  end

  def recommendation(is_fraud)
    is_fraud ? 'deny' : 'approve'
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
      ).merge({ transaction_date: Time.zone.now })
  end
end
