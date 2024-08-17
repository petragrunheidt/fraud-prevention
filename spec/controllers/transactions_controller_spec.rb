require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  context 'POST #create' do
    let(:post_params) {
      {
        merchant_id: '26174',
        user_id: '51999',
        card_number: '522241******5177',
        transaction_date: Time.zone.now.to_s,
        transaction_amount: '1000.0',
        device_id: '16511'
      }
    }
    let(:response_params) { %w[transaction_id recommendation] }

    it 'creates a new transaction' do
      expect {
        post :create, params: { transaction: post_params }
      }.to change(Transaction, :count).by(1)

      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(parsed_body.keys).to match_array response_params

      expect(parsed_body['transaction_id'].class).to be Integer
      expect(parsed_body['recommendation']).to be_in(%w[approve deny])
    end
  end
end
