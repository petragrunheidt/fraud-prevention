module DetectCsvOptions
  def detect_csv_options
    sample = csv_body.lines[0..10].join
    col_sep = detect_col_sep(sample)
    row_sep = detect_row_sep(csv_body)
    headers = true

    {
      col_sep:,
      row_sep:,
      headers:
    }
  end

  private

  def detect_col_sep(sample)
    potential_sep_chars = sample.gsub(/"[^"]*"/, '').scan(/[^a-zA-Z0-9]/)

    counts = potential_sep_chars.each_with_object(Hash.new(0)) { |char, hash| hash[char] += 1 }

    counts.max_by { |_, count| count }&.first
  end

  def detect_row_sep(csv_body)
    return "\r\n" if csv_body.include?("\r\n")

    return "\n" if csv_body.include?("\n")

    raise 'could not detect row separator for the csv file'
  end
end
