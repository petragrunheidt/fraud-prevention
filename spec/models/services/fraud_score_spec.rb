require 'rails_helper'

RSpec.describe Services::FraudScore do
  describe '.fraud_score' do
    let(:transaction) {
      create(:transaction, transaction_amount: 100.0, user_id: 1, device_id: 2, merchant_id: 3,
                           transaction_date: Time.zone.now)
    }

    subject { described_class.fraud_score(transaction) }

    before do
      allow(Queries::TransactionAmountOutlier)
        .to receive(:outlier?).and_return(false)
      allow(Queries::RecentUserTransaction)
        .to receive(:recent_transactions_count).and_return(0)
      allow(Queries::PreviousFraudPercentage)
        .to receive(:normalized_percentage).and_return(0.0)
    end

    context 'when transaction amount is not an outlier' do
      it 'returns a score of 0 for outlier_transaction_amount_score' do
        expect(subject).to eq(0)
      end
    end

    context 'when transaction amount is an outlier' do
      it 'returns the correct score for outlier_transaction_amount_score' do
        allow(Queries::TransactionAmountOutlier)
          .to receive(:outlier?).and_return(true)

        expect(subject).to be > 0
      end
    end

    context 'when the user has two recent transactions' do
      it 'returns a score of 10.0 for recent_transaction_score' do
        allow(Queries::RecentUserTransaction)
          .to receive(:recent_transactions_count).and_return(2)

        expect(subject).to eq(10.0)
      end
    end

    context 'when the user has no recent transactions' do
      it 'returns a score of 0 for recent_transaction_score' do
        expect(subject).to eq(0)
      end
    end

    context 'when previous fraud percentage is 0.0' do
      it 'returns a score of 0 for previous_frauds_score' do
        expect(subject).to eq(0)
      end
    end

    context 'when previous fraud percentage is between 0.2 and 0.5' do
      it 'returns a fraud score greater than 0' do
        allow(Queries::PreviousFraudPercentage)
          .to receive(:normalized_percentage).and_return(0.3)

        expect(subject).to be > 0
      end
    end

    context 'when previous fraud percentage is above 0.5' do
      it 'returns a fraud score greater than 0' do
        allow(Queries::PreviousFraudPercentage)
          .to receive(:normalized_percentage).and_return(0.6)

        expect(subject).to be > 0
      end
    end
  end
end
