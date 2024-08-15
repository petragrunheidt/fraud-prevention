require 'csv'
require_relative '../spec_helper'
require './lib/csv_parser'
require './lib/transactions_importer'

RSpec.describe TransactionsImporter do
  let(:csv_path) { './data.csv' }

  context 'when parsing the sample csv file' do
    it 'parses csv file into a hash with breakfast information' do
      csv_data = CsvParser.call(csv_path).sample(10)

      expect { described_class.call(csv_data) }.to change { Transaction.count }

    end
  end
end
