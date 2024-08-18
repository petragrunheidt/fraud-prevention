# This test file is not named _spec, because it is a special test file meant to be ran manually
require 'rails_helper'
require './lib/csv_parser'
require './lib/transactions_importer'

RSpec.describe 'Multiple Transactions', type: :request do
  before do
    csv_data = CsvParser.call('./data.csv')
    TransactionsImporter.call(csv_data)
  end

  context 'when testing for requests with random samples already in the database' do
    let(:transactions) { Transaction.order('RANDOM()').limit(100) }

    it 'correctly predicts fraud for over 90% of entries' do
      request_params_list = transactions.map do |t|
        {
          transaction_amount: t.transaction_amount,
          merchant_id: t.merchant_id,
          user_id: t.user_id,
          card_number: t.card_number,
          device_id: t.device_id
        }
      end

      request_params_list.each do |r|
        post '/transactions', params: { transaction: r }
      end

      new_transactions = Transaction.last(100)

      count = transactions.zip(new_transactions).count { |t, nt| t.has_cbk == nt.has_cbk }

      expect(count.to_f / 100).to be > 0.9
    end
  end
end
