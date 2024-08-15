FactoryBot.define do
  factory :transaction do
    transaction_id { rand(1..100_000) }
    merchant_id { rand(1..100_000) }
    user_id { rand(1..100_000) }
    card_number { "#{rand(100000..999999)}******#{rand(1000..9999)}" }
    transaction_date { rand(DateTime.now - 1.year..DateTime.now) }
    transaction_amount { BigDecimal(rand(1.0..100_000.0).round(2).to_s) }
    device_id { rand(1..100_000) }
    has_cbk { rand < 0.1 } # 10% chance of being true
  end
end
