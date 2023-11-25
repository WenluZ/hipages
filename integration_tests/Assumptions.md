Below are notes on assumptions and respective approaches for each task:

### Task 1: Fix the failing tests
 
One test, validating uniqueness based on the contact ID, is failing due to two distinct records sharing the same ID (3458a748-e9bb-47bc-a3f2-c9bf9c6316b9). To resolve this issue, we need to collaborate with the data source team to identify the root cause.

Before understanding the underlying problem, there are two potential approaches to rectify the failing test:
  1. One option is to fix the source file to remove the duplicate record
  2. Or temporarily commenting out this test until we know the business requirement more clear, and depute within our data warehouse by ordering a cnc column

As an interim solution, I'll temporarily delete the duplicate record.

### Task 3: We want to ensure our `transactions` data is not older than 1 day. How to do this and when to run these checks?

There are two ways to interpret this requirement:
1. transaction_date in the transactions data not older than 1 day
2. the seed load time of transaction data not older than 1 day 

To solve the 1st, a dbt_utils.recency dbt test can be added into _web__sources.yml file. Test is against transaction_date field. The test should be run every since the data is loaded.
I've set the severty as warn to avoid hard failure as the max(transaction_date) in the database is 2023-05-09 09:12:21.000.

To solve the 2nd, i've created a macro update_or_add_load_ts to use as a post hook to update load_ts column. Test is in place in _web__sources to test against this column


#### Task 4: Add tests for macros

1. test for macro age_in_years:
customer360/tests/test_macro_age_in_years.sql
2. test for as_timestamp_utc:
customer360/tests/test_macro_as_timestamp_utc.sql


#### Task 5:  Macros contain Postgres-specific functions, however our production environment is in Databricks. How would you refactor them, to allow switching between these two syntax?

have updated two marcos:
- age_in_years
- as_timestamp_utc



