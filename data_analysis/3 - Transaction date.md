### transaction date analysis

  When looking at transaction dates and times, it only makes sense in the context of the same person performing many transactions in a short period.
  This can be looked at by `user_id`, `card_number` or `device_id`.

  Let's start then by grouping or data by user and filtering out data from users that performed more than one transaction.

  ```rb
  grouped_by_user = data_hash.group_by { |d| d[:user_id] }

  def filter_by_multiple_transactions(data)
    data.select do |user_id, transactions|
      transactions.size > 1
    end
  end

  filtered_users = filter_by_multiple_transactions(grouped_by_users)
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

          t[:time_diff_seconds] = (diff * 24 * 60 * 60).to_i
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

  This is a simplified measurement, but if shows that there is a significant difference in both samples, which indicates that time from last transaction is a relevant indicator of Fraud