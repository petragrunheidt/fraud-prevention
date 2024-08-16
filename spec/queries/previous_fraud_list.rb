require 'rails_helper'

RSpec.describe Queries::PreviousFraudList do
  describe '.previous_fraud_list_percentages' do
    let(:user_id) { 100 }
    let(:device_id) { 200 }
    let(:merchant_id) { 300 }

    before do
      create(:transaction, user_id: user_id, device_id: device_id, merchant_id: merchant_id, has_cbk: true)
      create(:transaction, user_id: user_id, device_id: device_id, merchant_id: merchant_id, has_cbk: false)
      create_list(:transaction, 3, user_id: user_id, has_cbk: true)
      create_list(:transaction, 3, device_id: device_id, has_cbk: false)
      create_list(:transaction, 3, merchant_id: merchant_id, has_cbk: true)
    end

    it 'returns the correct fraud percentages for each attribute' do
      percentages = described_class.previous_fraud_list_percentages(user_id, device_id, merchant_id)

      expect(percentages[:user_id]).to eq(0.8)
      expect(percentages[:device_id]).to eq(0.2)
      expect(percentages[:merchant_id]).to eq(0.8)
    end

    it 'returns 0.0 if no transactions for an attribute' do
      percentages = described_class.previous_fraud_list_percentages(101, 202, 303)

      expect(percentages[:user_id]).to eq(0.0)
      expect(percentages[:device_id]).to eq(0.0)
      expect(percentages[:merchant_id]).to eq(0.0)
    end
  end
end
