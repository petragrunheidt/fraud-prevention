class Queries::PreviousFraudPercentage
  def initialize(user_id, device_id, merchant_id)
    @user_id = user_id
    @device_id = device_id
    @merchant_id = merchant_id
  end

  def self.normalized_percentage(user_id, device_id, merchant_id)
    new(user_id, device_id, merchant_id).normalized_percentage
  end

  def normalized_percentage
    percentages = previous_fraud_list_percentages.values

    percentages.sum / percentages.size.to_f
  end

  private

  attr_reader :user_id, :device_id, :merchant_id

  def previous_fraud_list_percentages
    { user_id:, device_id:, merchant_id: }.each_with_object({}) do |(k, v), acc|
      fraud_percentage = attribute_frauds_percentage({ k => v })
      acc[k] = fraud_percentage
    end
  end

  def attribute_frauds_percentage(attribute)
    result = Transaction.where(attribute)
                        .group(:has_cbk)
                        .count

    return 0.0 if result.values.sum.zero? || result[true].nil?

    (result[true].to_f / result.values.sum)
  end
end
