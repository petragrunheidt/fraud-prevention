require 'rails_helper'

RSpec.describe Queries::PreviousFraudPercentage do
  describe '.normalized_percentage' do
    let(:device_id) { 200 }
    let(:merchant_id) { 300 }

    before do
      create(:transaction, device_id:, merchant_id:,
                           has_cbk: true)
      create(:transaction, device_id:, merchant_id:,
                           has_cbk: false)
      create_list(:transaction, 3, has_cbk: true)
      create_list(:transaction, 3, device_id:, has_cbk: false)
      create_list(:transaction, 3, merchant_id:, has_cbk: true)
    end

    it 'returns the correct fraud percentages for each attribute' do
      normalized_percentage = described_class
                              .normalized_percentage(device_id, merchant_id)

      expect(normalized_percentage).to eq(0.5)
    end

    it 'when only one attribute matches a previous transaction' do
      normalized_percentage = described_class
                              .normalized_percentage(202, merchant_id)

      expect(normalized_percentage).to be 0.8 / 2.0
    end

    it 'returns 0.0 if no transactions for an attribute' do
      normalized_percentage = described_class
                              .normalized_percentage(202, 303)

      expect(normalized_percentage).to eq(0.0)
    end

    context 'when there are nil values for the arguments' do
      it 'calculates correct percentage when device_id is nil' do
        normalized_percentage = described_class
                                .normalized_percentage(nil, merchant_id)

        expect(normalized_percentage).to eq((0.8 + 0) / 2.0)
      end

      it 'returns 0.0 when all values are nil' do
        normalized_percentage = described_class
                                .normalized_percentage(nil, nil)

        expect(normalized_percentage).to eq(0.0)
      end
    end
  end
end
