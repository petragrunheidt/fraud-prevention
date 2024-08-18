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
    let(:parsed_response) { JSON.parse(response.body) }
    let(:response_params) { %w[transaction_id recommendation] }

    it 'creates a new transaction' do
      expect {
        post :create, params: { transaction: post_params }
      }.to change(Transaction, :count).by(1)

      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(parsed_response.keys).to match_array response_params

      expect(parsed_response['transaction_id'].class).to be Integer
      expect(parsed_response['recommendation']).to be_in(%w[approve deny])
    end

    context '.flag_fraud?' do
      it 'blocks transaction if FraudBlock should_block? is true' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(true)

        post :create, params: { transaction: post_params }

        expect(parsed_response['recommendation']).to eq 'deny'
      end

      it 'should not block transaction if FraudBlock should_block? is false' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)

        post :create, params: { transaction: post_params }
        expect(parsed_response['recommendation']).to eq 'approve'
      end

      it 'blocks transaction if fraud score is greater than 15' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(16)

        post :create, params: { transaction: post_params }

        expect(parsed_response['recommendation']).to eq 'deny'
      end

      it 'does not block transaction if fraud score is less than 15' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(14)

        post :create, params: { transaction: post_params }

        expect(parsed_response['recommendation']).to eq 'approve'
      end
    end
  end
end
