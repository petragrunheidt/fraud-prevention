class Queries::PreviousFraudList
  def initialize(user_id, device_id, merchant_id)
    @user_id = user_id
    @device_id = device_id
    @merchant_id = merchant_id
  end

  def self.previous_fraud_list_percentages(user_id, device_id, merchant_id)
    new(user_id, device_id, merchant_id).previous_fraud_list_percentages
  end

  def previous_fraud_list_percentages
    {user_id:, device_id:, merchant_id:}.each_with_object({}) do |(k, v), acc|
      fraud_percentage = attribute_frauds_percentage({k => v})
      acc[k] = fraud_percentage
    end
  end

  private

  attr_reader :user_id, :device_id, :merchant_id

  def attribute_frauds_percentage(attribute)
    result = Transaction.where(attribute)
                        .group(:has_cbk)
                        .count

    return 0.0 if result.values.sum.zero? || result[true].nil?

    (result[true].to_f / result.values.sum)
  end
end
