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

    context 'when posting a transaction data' do
      it 'and it is approved' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(0)

        expect {
          post :create, params: { transaction: post_params }
        }.to change(Transaction, :count).by(1)
        expect(response.status).to eq 200
        expect(parsed_response.keys).to match_array %w[transaction_id recommendation]
        expect(parsed_response['transaction_id'].class).to be Integer
        expect(parsed_response['recommendation']).to eq 'approve'
      end

      it 'and it is denied' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(true)

        expect {
          post :create, params: { transaction: post_params }
        }.not_to change(Transaction, :count)
        expect(response.status).to eq 200
        expect(parsed_response).not_to have_key 'transaction_id'
        expect(parsed_response['recommendation']).to eq 'deny'
      end
    end

    context 'when receiving http error statuses' do
      it 'bad_request' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(0)

        post :create, params: { transaction: { badbad: 'not good params' } }

        expect(response.status).to eq 400
        expect(parsed_response['message']).to eq 'Bad request'
      end
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

      it 'blocks transaction if fraud score is greater than 60' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(100)

        post :create, params: { transaction: post_params }

        expect(parsed_response['recommendation']).to eq 'deny'
      end

      it 'does not block transaction if fraud score is less than 60' do
        allow(Services::FraudBlock).to receive(:should_block?).and_return(false)
        allow(Services::FraudScore).to receive(:fraud_score).and_return(14)

        post :create, params: { transaction: post_params }

        expect(parsed_response['recommendation']).to eq 'approve'
      end
    end
  end
end
