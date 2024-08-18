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

      predictions_and_original_cbk = []
      request_params_list.each_with_index do |r, i|
        post '/transactions', params: { transaction: r }
        recommendation = JSON.parse(response.body)['recommendation']
        predictions_and_original_cbk << { recommendation:, original_cbk: transactions[i].has_cbk }
      end

      correct_predictions_count = predictions_and_original_cbk.count do |prediction|
        prediction[:recommendation] == (prediction[:original_cbk] ? 'deny' : 'approve')
      end

      correct_predictions_percentage = correct_predictions_count.to_f / 100
      expect(correct_predictions_percentage).to be > 0.9
      puts format('Correct predictions: %.2f%%', correct_predictions_percentage * 100)
    end
  end
end
