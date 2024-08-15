require 'rails_helper'

RSpec.describe Queries::RecentUserTransaction do
  context 'time_from_last_transaction' do
    let(:user_id) { 10 }
    before do
      FactoryBot.create(:transaction, user_id:, transaction_date: Time.zone.now - 6.hours)
    end

    it 'returns the difference between the provided date and the last transaction from the user' do
      result = described_class.time_from_last_transaction(user_id: user_id, transaction_date: Time.zone.now)

      expect(result).to be_within(0.1).of Time.zone.now - (Time.zone.now - 6.hours)
    end

    it 'returns nil if this is the first transaction of this user' do
      result = described_class.time_from_last_transaction(user_id: 11, transaction_date: Time.zone.now)

      expect(result).to be nil
    end

    it 'ensures the transaction with the most recent date is picked' do
      result = described_class.time_from_last_transaction(user_id: user_id, transaction_date: Time.zone.now)

      FactoryBot.create(:transaction, user_id: user_id, transaction_date: Time.zone.now - 12.hours) # another transaction

      expect(result).to be_within(0.1).of Time.zone.now - (Time.zone.now - 6.hours)
    end
  end
end
