### transaction amount analysis

  Starting with a basic analysis of the transaction amount, I will be collecting the mean, the variance and the standart deviation:

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
      is_outlier = z_score(amount, mean, std_dev). abs > 3

      outliers << point if is_outlier
    end
  ```

  The result is 92 outliers from the 3199 dataset, now let's investigater their has_cbk value

  ```rb
    outliers_cbks = outliers.map { |hash| hash[:has_cbk] }
    outliers.count("TRUE") # returns 43
    outliers.count("FALSE") # returns 49
  ```
  Compared to the full data set with 391 `"TRUE"` and 2808`"FALSE"`, this is probably a significant attribute for the analysis of fraud, but not an absolute one