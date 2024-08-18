# Transaction Amount Analysis

  In this section we'll perform a basic analysis of the transaction amount, we will be collecting the mean, variance, and standard deviation:

  ```rb
    transaction_amounts = data_hash.map { |row| row[:transaction_amount].to_f }

    mean = transaction_amounts.sum / transaction_amounts.size
    variance = transaction_amounts.map { |x| (x - mean)**2 }.sum / transaction_amounts.size
    std_deviation = Math.sqrt(variance)
  ```

  For this dataset, the values are:

  ```rb
    mean = 767.81
    variance = 790244.42
    std_deviation = 888.95
  ```

  This allows us to find ouliters by calculating the z_score with:

  ```rb
    def z_score(value, mean, std_dev)
      (value - mean) / std_dev
    end
  ```

  Now we can filter out outlier values by doing:

  ```rb
    outliers = []

    data_hash.each do |point|
      amount = point[:transaction_amount].to_f
      is_outlier = z_score(amount, mean, std_deviation). abs > 3

      outliers << point if is_outlier
    end
  ```

  The result is 92 outliers from the 3199 dataset, now let's investigater their has_cbk value

  ```rb
    cbk_proportion(outliers)
  ```

  The size of the sample is: 92
  Proportion with chargeback: 46.74%
  Proportion without chargeback: 53.26%

  Compared to the full data set with `8.2%` of frauds the value of `46.7%` shows that this is probably a significant attribute for the analysis of fraud.
  