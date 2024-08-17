class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(
      transaction_date: Time.zone.now,
      **transaction_params
    )
    transaction.has_cbk = flag_fraud? transaction

    return :unprocessable_entity unless transaction.save!

    response = { transaction_id: transaction.transaction_id, recommendation: 'approve' }

    render json: response, status: :ok
  end

  private

  def flag_fraud?(transaction)
    fraud_score = Services::FraudScore.fraud_score(transaction)

    fraud_score > 15
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
      )
  end
end
