# Fraud detection API

## Description

This API is a simple Rails application that tries to detect fraud on a series of transactions.

## Requirements

- Ruby 3.3
- Rails 7.2
- Postgres

## How to run

### Docker

You can start the application with a docker compose file and create the initial database with:

- `docker compose build`
- `docker compose up`
- `docker exec fraud rails db:create`

## How to test

To test the application with docker you can bash into the container with:

- `docker exec -it fraud bash`

And then run the tests with `rspec`.

## Special tests

There is a special test that tests the success rate of the fraud analysis. You can run it with:

- `rspec spec/requests/multiple_transactions`

## Why Rails?

  Initially, I planned on running a simple Sinatra server to run simple Ruby scripts to analyze the data, but it became clear that the computations would be too slow. Rails is a convenient way to have a database configured to run queries efficiently.

## Data analysis

  The reports of data analysis on the data sample can be found in the `analysis_journals` folder.
  The conclusions from these reports served as a basis for the development of the detection algorithm.
