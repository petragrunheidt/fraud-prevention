# Device id analysis

## device_id missing?

  On a simple inspection through the csv, it is noticeable that some transactions don't have a `device_id`. Assuming all transactions are from mobile devices, it is suspicious that a device will go unregistered. Let's investigate the rate os frauds in entries without a device_id

  ```rb
    no_device_id = data_hash.select { |t| t[:device_id].nil? }
  ```

  830 records don't have a device id, about `26%` of all transactions.
  Let's check out which of those are flagged with has_cbk:
  `has_cbk == "TRUE"`: 67
  `has_cbk == "FALSE"`: 763
  That is `8.7%`, only slightly higher than the global average, so this is probably not a good parameter to analyze fraud.

## device is already associated with frauds

  Devices that were involved in the past with frauds are more likely to be involved with frauds again. To identify such devices, we can group our data by device_id and filter by those with a history of fraud. While we are at it, we should also exclude the first flagged transaction and the ones before it, and only analyze the remainder, because what we want to know is: "after a fraud happened with a certain `device_id`, is it more likely to happen again with the same device?".

  ```rb
    device_fraud_history = data_hash.group_by { |d| d[:device_id] }.select do |device_id, transactions|
      next unless transactions.size > 1 && transactions.any? { |t| t[:has_cbk] == "TRUE" }

      first_fraud_index = transactions.index { |t| t[:has_cbk] == "TRUE" }
      next unless first_fraud_index

      transactions[(first_fraud_index + 1)..-1]
    end
  ```

  Let's now count the total number of transactions that have has_cbk set to true or false within this scope:

  ```rb
    transactions_with_flagged_devices = device_fraud_history.values.flatten

    fraud_count = transactions_with_flagged_devices.count { |t| t[:has_cbk] == "TRUE" }
    non_fraud_count = transactions_with_flagged_devices.count { |t| t[:has_cbk] == "FALSE" }
  ```

  In this scope, the percentage of frauds is significantly high at `84.95%`.
  This seems to be the most significant parameter we found so far, but with a smaller scope of transactions, because only `319` records match all of the conditions

## could the same be true for other attributes already associated with frauds?

  From all our attributes:

- **merchant_id**: this attribute could be particularly relevant. Just as devices can be linked to multiple frauds, certain merchants might also have a history of fraud-related transactions.
- **user_id**: similar to merchant_id, analyzing `user_id` could reveal whether certain users are associated with a higher number of fraudulent transactions.
- card_number: could be a relevant identifier, but since the information isn't complete, `user_id` would be more reliable.
- transaction_date: probably not relevant in isolation.
- transaction_amount already best analyzed with the z_score method.

  Let's abstract a method from what we did with device_id:

  ```rb
  def simple_associative_cbk_analysis(data, att)
    grouped_data = data.group_by { |d| d[att.to_sym] }.select do |k, v|

      first_fraud_index = v.index { |t| t[:has_cbk] == "TRUE" }
      next unless first_fraud_index && v.size > 1

      v[(first_fraud_index + 1)..-1]
    end
    transactions_with_flagged_groups = grouped_data.values.flatten.compact

    puts "Proportions for #{att} analysis:\n"

    puts "Sample size: #{transactions_with_flagged_groups.size}"
    cbk_proportion(transactions_with_flagged_groups)
  end

  simple_associative_cbk_analysis(data_hash, :user_id)
  simple_associative_cbk_analysis(data_hash, :merchant_id)
  ```

  **Proportions for user_id analysis:**

  Sample size: 391
  Proportion with chargeback: 83.86%
  Proportion without chargeback: 16.37%

  **Proportions for merchant_id analysis:**

  Sample size: 496
  Proportion with chargeback: 71.57%
  Proportion without chargeback: 28.43%

  We could say that the analysis of user_id is as strongly relevant for detecting frauds as the analysis of device_id.
  Also, the analysis of merchant_id seems to be relevant, but less so than the other two.
