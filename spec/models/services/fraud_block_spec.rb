require 'rails_helper'

RSpec.describe Services::FraudBlock do
  context 'should_block?' do
    context 'previous user fraud rule' do
      let(:user_id) { 10 }
      before do
        create(:transaction, user_id:, has_cbk: true)
        create(:transaction, user_id:, has_cbk: false)
      end

      it 'returns true if user had a chargeback before' do
        transaction = build(:transaction, user_id:)

        expect(described_class.should_block?(transaction)).to be_truthy
      end

      it 'returns false if user did not had a chargeback before' do
        create(:transaction, user_id:, has_cbk: false)
        transaction = build(:transaction, user_id: 11)

        expect(described_class.should_block?(transaction)).to be_falsey
      end

      it 'returns false on first transaction' do
        transaction = build(:transaction, user_id: 12)

        expect(described_class.should_block?(transaction)).to be_falsey
      end
    end

    context 'recent transaction rule' do
      let(:user_id) { 10 }
      before do
        create_list(:transaction,
                    2,
                    user_id:,
                    transaction_date: Time.zone.now - 1.hours,
                    has_cbk: false)
      end

      it 'returns false if recent transactions count is less than 3' do
        transaction = build(:transaction, user_id:, transaction_date: Time.zone.now)

        expect(described_class.should_block?(transaction)).to be_falsey
      end

      it 'returns true if recent transactions count is 5 or greater' do
        create_list(:transaction,
                    3,
                    user_id:,
                    transaction_date: Time.zone.now - 1.hours,
                    has_cbk: false)
        transaction = build(:transaction, user_id:, transaction_date: Time.zone.now)

        expect(described_class.should_block?(transaction)).to be_truthy
      end

      context 'when recent transactions count it between 3 and 5' do
        before do
          create_list(:transaction,
                      2,
                      user_id:,
                      transaction_date: Time.zone.now - 1.hours,
                      has_cbk: false)
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
