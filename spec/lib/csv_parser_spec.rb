require 'csv'
require_relative '../spec_helper'
require './lib/csv_parser'

RSpec.describe CsvParser do
  let(:csv_path) { './data.csv' }
  let(:sample_keys) do
    %i[
      transaction_id
      merchant_id
      user_id
      card_number
      transaction_date
      transaction_amount
      device_id
    ]
  end

  context 'when parsing the sample csv file' do
    it 'parses csv file into a hash with breakfast information' do
      parsed_list = described_class.call(csv_path)

      expect(parsed_list[0]).to include(*sample_keys)
    end
  end
end
