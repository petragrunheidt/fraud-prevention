require 'rails_helper'

RSpec.describe Queries::PreviousFraudPercentage do
  describe '.previous_fraud_list_percentages' do
    let(:user_id) { 100 }
    let(:device_id) { 200 }
    let(:merchant_id) { 300 }

    before do
      create(:transaction, user_id:, device_id:, merchant_id:,
                           has_cbk: true)
      create(:transaction, user_id:, device_id:, merchant_id:,
                           has_cbk: false)
      create_list(:transaction, 3, user_id:, has_cbk: true)
      create_list(:transaction, 3, device_id:, has_cbk: false)
      create_list(:transaction, 3, merchant_id:, has_cbk: true)
    end

    it 'returns the correct fraud percentages for each attribute' do
      normalized_percentage = described_class
                              .normalized_percentage(user_id, device_id, merchant_id)

      expect(normalized_percentage).to eq(0.6)
    end

    it 'when only one attribute matches a previous transaction' do
      normalized_percentage = described_class
                              .normalized_percentage(user_id, 202, 303)

      expect(normalized_percentage).to be 0.8 / 3.0
    end

    it 'returns 0.0 if no transactions for an attribute' do
      normalized_percentage = described_class
                              .normalized_percentage(101, 202, 303)

      expect(normalized_percentage).to eq(0.0)
    end
  end
end
