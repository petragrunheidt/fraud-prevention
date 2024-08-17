### transaction date analysis

  When looking at transaction dates and times, it only makes sense in the context of the same person performing many transactions in a short period.
  This can be looked at by `user_id`, `card_number` or `device_id`.

  Let's start then by grouping or data by user and filtering out data from users that performed more than one transaction.

  ```rb
  grouped_by_user = data_hash.group_by { |d| d[:user_id] }

  def filter_by_multiple_transactions(data)
    data.select do |user_id, transactions|
      transactions.size > 3
    end
  end

  filtered_users = filter_by_multiple_transactions(grouped_by_user)
  ```

  For startes we have a very reduced sample, only 235 users repeated a transaction.
  Now let's investigate the time between the transactions of each user and the transaction that came before:

  First we'll sorte each users transactions by date and time

  ```rb
  def sort_user_transactions(data)
    data.transform_values do |ts|
      ts.each do |t|
        t[:transaction_date] = DateTime.parse(t[:transaction_date])
      end

      ts.sort_by { |t| t[:transaction_date] }
    end
  end

  sorted_and_filtered_users = sort_user_transactions(filtered_users)
  ```

  Now for each transaction, lets check the time difference between it and the previous transaction and add it to the object:

  ```rb
    def add_time_diff_data(data)
      data.each do |_, ts|
        ts.each_with_index do |t, i|
          if i == 0
            t[:time_diff_seconds] = nil
            next
          end

          previous_t = ts[i - 1]
          diff =  t[:transaction_date] - previous_t[:transaction_date]

          t[:time_diff_seconds] = (diff * 24 * 60 * 60).to_f
        end 
      end
    end

    users_with_time_difference = add_time_diff_data(sorted_and_filtered_users)
  ```

  Now each transaction has information about the difference in seconds comparted the last transaction by the same user
  Let's now check if there is correlation between this and frauds:

  ```rb
    # filtering out first time transactions
    valid_transactions = users_with_time_difference.values.flatten.select { |t| t[:time_diff_seconds] != nil }

    unfraudulent_transactions = valid_transactions.select { |t| t[:has_cbk] == "FALSE" }
    fraudulent_transactions = valid_transactions.select { |t| t[:has_cbk] == "TRUE" }

    def mean_time_diff(transactions)
      total_diff = transactions.sum { |t| t[:time_diff_seconds] }
      mean_diff = total_diff.to_f / transactions.size
      mean_diff
    end

    not_fraud_mean = mean_time_diff(unfraudulent_transactions) # about 56 hours, 16 minutes, and 2.73 seconds.
    fraud_mean = mean_time_diff(fraudulent_transactions) # about 16 hours, 0 minutes, and 43.62 seconds.
  ```

  This is a simplified measurement, but it shows that there is a significant difference in both samples.

  Now, let's add another simple measurement. I'm going to take the valid_transactions array, split it into two groups, one with a time difference greater than 24 hours and one with a lower time difference, and analyze the amount of chargebacks.

  ```rb
  lower_group = []
  upper_group = []
  
  one_day = 24 * 60 * 60
  valid_transactions.each do |t|
    time_diff_days = t[:time_diff_seconds] / one_day

    time_diff_days > 1 ? upper_group << t : lower_group << t
  end 
  ```

  Analyzing both groups with our cbk_proportion function, we get:

  upper_group:
    - Proportion with chargeback: `29.55%`
    - Proportion without chargeback: `70.45%`

  lower_group:
    - Proportion with chargeback: `60.88%`
    - Proportion without chargeback: `39.12%`

  Both groups have a higher rate os chargebacks than the main sample, but the difference in the lower group is a lot more significant. This indicates that the time since the last transaction is a relevant indicator of fraud.

### Pre defined date rule

A good practice for transaction fraud prevention is setting a limit on the number of transactions a user can make within a specific timeframe. In our dataset, few users (48 examples) have more than three transactions. However, for those who do, the incidence of fraud increases significantly, and the average time between transactions decreases for the group flagged for fraud.

By applying the same logic in Ruby, but flagging users with more than three transactions, the average time between transactions drops to less than 12 hours.

In real-life scenarios, it's plausible for someone to make several small transactions, such as buying groceries and picking up small items from different merchants. However, multiple high-value transactions are a strong indicator of fraud. If it's a false positive, the user is likely to understand why their transaction was flagged as a fraud if the value is high.

We could derive a reasonable static rule for this such as, after 3 transactions within 12 hours, the user can only perform transactions of small value, and after 5 total purchases the user is blocked.
