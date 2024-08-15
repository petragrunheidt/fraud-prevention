require 'bigdecimal'

class TransactionsImporter
  def initialize(transactions_hash)
    @transactions_hash = transactions_hash
  end

  def self.call(transactions_hash)
    new(transactions_hash).call
  end

  def call
    transactions_hash.each do |t|
      parsed_params = builld_transaction(t)

      Transaction.create!(parsed_params)
    end
  end

  private

  attr_reader :transactions_hash

  def builld_transaction(t_hash)
    {
      merchant_id: t_hash[:merchant_id].to_i,
      user_id: t_hash[:merchant_id].to_i,
      card_number: t_hash[:card_number],
      transaction_date: DateTime.parse(t_hash[:transaction_date]),
      transaction_amount: BigDecimal(t_hash[:transaction_amount]).round(2),
      device_id: t_hash[:device_id].to_i,
      has_cbk: t_hash[:has_cbk] == "TRUE"
    }
  end
end