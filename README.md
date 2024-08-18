# Fraud Detection API

## Description

  This API is a simple Rails application designed to detect fraud in a series of transactions.

## Specs

- **Ruby**: 3.3
- **Rails**: 7.2
- **Postgres**

## How to Run

### Docker

  To start the application using Docker and set up the initial database, execute the following commands:

1. Build the Docker images:

```bash
docker compose build
```

2. Start the application:

```bash
docker compose up
```

3. Create the initial database:

```bash
docker exec fraud rails db:create
```

## How to Test

To run tests using Docker, follow these steps:

1. Bash into the container:

```bash
docker exec -it fraud bash
```

2. Run the tests with RSpec:

```bash
rspec
```

## Special tests

  There is a dedicated test designed to evaluate the success rate of the fraud detection algorithm. You can run it with:

```bash
rspec spec/requests/multiple_transactions.rb
```

  This test populates the database with data from the CSV file, selects samples from the database, and checks whether the model accurately predicts the has_cbk value in more than 90% of the cases.

## Data analysis

  The reports of data analysis on the data sample can be found in the `analysis_journals` folder.
  The conclusions from these reports served as a basis for the development of the detection algorithm.
