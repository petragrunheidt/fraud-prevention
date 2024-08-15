require 'rails_helper'
require 'bigdecimal'

RSpec.describe Queries::TransactionAmountOutlier do
  context '.is_outlier?' do
    before do
      (10..20).each do |amount|
        FactoryBot.create_list(:transaction, 100, transaction_amount: amount)
      end
    end

    it 'returns true if the transaction amount is an outlier' do
      result = Queries::TransactionAmountOutlier.is_outlier?(BigDecimal(5000))
      expect(result).to be true
    end

    it 'returns false if the transaction amount is not an outlier' do
      result = Queries::TransactionAmountOutlier.is_outlier?(BigDecimal(18))
      expect(result).to be false
    end
  end
end
