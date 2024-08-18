# Reject transaction if a user had a chargeback before (note that this information does not comes on the payload.
#  The chargeback data is received days after the transaction was approved)

class Queries::PreviousFraudPercentage
  def initialize(device_id, merchant_id)
    @device_id = device_id
    @merchant_id = merchant_id
  end

  def self.normalized_percentage(device_id, merchant_id)
    new(device_id, merchant_id).normalized_percentage
  end

  def normalized_percentage
    percentages = previous_fraud_list_percentages.values

    percentages.sum / percentages.size.to_f
  end

  private

  attr_reader :device_id, :merchant_id

  def previous_fraud_list_percentages
    { device_id:, merchant_id: }.each_with_object({}) do |(k, v), acc|
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
