### Device id analysis

#### device_id missing?

  On a simple inspection through the csv, it is noticeable that some transactions don't have a `device_id`. Assuming all transactions are from mobile devices, it is suspicious that a device will go unregistered. Let's investigate the rate os frauds in entries without a device_id

  ```rb
    no_device_id = data_hash.select { |t| t[:device_id].nil? }
  ```

  830 records don't have a device id, about `26%` of all transactions.
  Let's check out which of those are flagged with has_cbk:
  `has_cbk == "TRUE"`: 67
  `has_cbk == "FALSE"`: 763
  That is `8.7%`, only slightly higher than the global average, so this is probably not a good parameter to analyze fraud.

#### device is already associated with frauds

  Devices that were involved in the past with frauds are more likely to be involved with frauds again. To identify such devices, we can group our data by device_id and filter by those with a history of fraud:

  ```rb
    device_fraud_history = data_hash.group_by { |d| d[:device_id] }.select do |device_id, transactions|
    device_id && transactions.any? { |t| t[:has_cbk] == "TRUE" }
  end
  ```

  Let's now count the total number of transactions that have has_cbk set to true or false within this scope:

  ```rb
    transactions_with_flagged_devices = device_fraud_history.values.flatten

    fraud_count = transactions_with_flagged_devices.count { |t| t[:has_cbk] == "TRUE" }
    non_fraud_count = transactions_with_flagged_devices.count { |t| t[:has_cbk] == "FALSE" }
  ```

  In this scope, the percentage of frauds is significantly high at `87%`.
  This is the most significant parameter we found so far, but with a smaller scope of transactions.
