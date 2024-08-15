## 3.2 - Get your hands dirty

  ### Building objects in ruby to analyze patterns in the dataset

  Disclaimer: this is the perfect use case for a jupyter notebook data analysis in python, but I'm using this markdown rubyter notebook all the same
  For this part of the project, I developed a simple csv parsing script that transforms the csv file into a hash so I can interact with the dataset.
  The starting point is running:

  ```rb
    require './lib/csv_parser'

    path = './data.csv'
    data_hash = CsvParser.call(path)
  ```

  - The dataset has `3199` records, `391` flagged for automatic fraud detection (about `8.2%`)
