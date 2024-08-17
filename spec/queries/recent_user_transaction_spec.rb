require 'rails_helper'

RSpec.describe Queries::RecentUserTransaction do
  context 'time_since_last_transaction' do
    let(:user_id) { 10 }
    before do
      FactoryBot.create(:transaction, user_id:, transaction_date: Time.zone.now - 6.hours)
    end

    it 'returns the difference between the provided date and the last transaction from the user' do
      result = described_class.time_since_last_transaction(user_id:,
                                                           transaction_date: Time.zone.now)

      expect(result).to be_within(0.1).of Time.zone.now - (Time.zone.now - 6.hours)
    end

    it 'returns nil if this is the first transaction of this user' do
      result = described_class.time_since_last_transaction(user_id: 11,
                                                           transaction_date: Time.zone.now)

      expect(result).to be nil
    end

    it 'ensures the transaction with the most recent date is picked' do
      result = described_class.time_since_last_transaction(user_id:,
                                                           transaction_date: Time.zone.now)
      # another transaction with older date
      FactoryBot.create(:transaction, user_id:, transaction_date: Time.zone.now - 12.hours)

      expect(result).to be_within(0.1).of Time.zone.now - (Time.zone.now - 6.hours)
    end
  end

  context '.recent_transactions_count' do
    let(:user_id) { 10 }
    before do
      [1, 2, 3, 4, 16, 20, 24, 28].each do |i|
        FactoryBot.create(:transaction, user_id:, transaction_date: Time.zone.now - i.hours)
      end
    end

    it 'returns the number of transactions in the last 12 hours (default)' do
      transactions_count = described_class
                           .recent_transactions_count(user_id:, transaction_date: Time.zone.now)

      expect(transactions_count).to eq 4
    end

    it 'returns the number of transactions within a custom treshold' do
      transactions_count = described_class
                           .recent_transactions_count(
                             user_id:,
                             transaction_date: Time.zone.now,
                             recent_threshold: 18.hours
                           )

      expect(transactions_count).to eq 5
    end
  end
end
