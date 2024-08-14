require 'csv'
require_relative 'concerns/detect_csv_options'

class CsvParser
  include DetectCsvOptions

  def initialize(csv)
    @csv_body = File.read(csv)
  end

  def self.call(csv)
    new(csv).call
  end

  def call
    build_hash_from
  end

  private

  attr_reader :csv_body

  def build_hash_from
    parsed_csv = parse_csv_body

    parsed_csv.each_with_object([]) do |csv_row, result|
      result << csv_row.to_h.transform_keys(&:to_sym)
    end
  end

  def parse_csv_body
    csv_options = detect_csv_options

    CSV.parse(csv_body, **csv_options)
  end
end
