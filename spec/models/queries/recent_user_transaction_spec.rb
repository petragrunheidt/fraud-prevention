require 'rails_helper'

RSpec.describe Queries::RecentUserTransaction do
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
