require 'rails_helper'

RSpec.describe Services::FraudBlock do
  context 'should_block?' do
    context 'recent transaction rule' do
      let(:user_id) { 10 }
      before do
        create_list(:transaction, 2, user_id:, transaction_date: Time.zone.now - 1.hours)
      end

      it 'returns false if recent transactions count is less than 3' do
        transaction = build(:transaction, user_id:, transaction_date: Time.zone.now)

        expect(described_class.should_block?(transaction)).to be_falsey
      end

      it 'returns true if recent transactions count is 5 or greater' do
        create_list(:transaction, 3, user_id:, transaction_date: Time.zone.now - 1.hours)
        transaction = build(:transaction, user_id:, transaction_date: Time.zone.now)

        expect(described_class.should_block?(transaction)).to be_truthy
      end

      context 'when recent transactions count it between 3 and 5' do
        before do
          create_list(:transaction, 2, user_id:, transaction_date: Time.zone.now - 1.hours)
        end
        it 'returns false if transaction amount is less than 300' do
          transaction = build(
            :transaction,
            user_id:,
            transaction_amount: 290.0,
            transaction_date: Time.zone.now
          )

          expect(described_class.should_block?(transaction)).to be_falsey
        end

        it 'returns true if transaction amount is greater than 300' do
          transaction = build(
            :transaction,
            user_id:,
            transaction_amount: 350.0,
            transaction_date: Time.zone.now
          )

          expect(described_class.should_block?(transaction)).to be_truthy
        end
      end
    end
  end
end
