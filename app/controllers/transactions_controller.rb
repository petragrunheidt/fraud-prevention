class TransactionsController < ApplicationController
  def create
    transaction = new_transaction(true)

    response = { transaction_id: transaction.transaction_id, recommendation: 'approve' }

    render json: response, status: :ok
  end

  private

  def new_transaction(has_cbk)
    @transaction = Transaction
                   .create!(
                     {
                       **transaction_params,
                       transaction_date: Time.zone.now,
                       has_cbk:
                     }
                   )
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
