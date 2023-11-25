Below are notes on assumptions and respective approaches for each task:

### Task 1: Fix the failing tests
 
One test, validating uniqueness based on the contact ID, is failing due to two distinct records sharing the same ID (3458a748-e9bb-47bc-a3f2-c9bf9c6316b9). To resolve this issue, we need to collaborate with the data source team to identify the root cause.

Before understanding the underlying problem, there are two potential approaches to rectify the failing test:
  1. One option is to fix the source file to remove the duplicate record
  2. Or temporarily commenting out this test until we know the business requirement more clear, and dedup within our data warehouse by ordering a cnc column

As an interim solution, I've temporarily deleted the duplicate record.

### Task 2: Add a test to validate the referential integrity of the `transactions` table

This has been added to _web__sources.yml.

### Task 3: We want to ensure our `transactions` data is not older than 1 day. How to do this and when to run these checks?

There are two ways to interpret this requirement:
1. Ensure transaction_date in the transactions data is not older than 1 day.
2. Ensure the seed load time of transaction data is not older than 1 day.

To solve the first, a dbt_utils.recency dbt test can be added to _web__sources.yml file, testing against the transaction_date field. The test should run every time the data is loaded. I've set the severity as warn to avoid hard failure, considering the maximum transaction_date in the database is 2023-05-09 09:12:21.000.
-
To solve the second, I've created a macro, update_or_add_load_ts, to use as a post hook to update the load_ts column. A test is in place in _web__sources to test against this column.


#### Task 4: Add tests for macros

1. test for macro age_in_years:
customer360/tests/test_macro_age_in_years.sql
2. test for as_timestamp_utc:
customer360/tests/test_macro_as_timestamp_utc.sql


#### Task 5:  Macros contain Postgres-specific functions, however our production environment is in Databricks. How would you refactor them, to allow switching between these two syntax?

I've updated two macros:
- age_in_years
- as_timestamp_utc


#### Task 6:  enhance the `customers` model

1. The model has been updated to enable additional customer attributes.
2. Created a singular test test_total_amount.sql, and added unique & not null tests into _marketing__models.yml
3. Created a macro to be used in the updated model get_distinct_values.sql.

#### Task 7:  Any other improvements ?

1. Enable incremental load and create dim (type 2)/fct tables (type 1) to capture changes.
2. Implement a consumption layer/feature store as an interact layer with downstream.
3. Set up a CI/CD pipeline.


#### Task 8:  

1. Product Category Recommender - how to implement Next Best Product Category?

- Potentail additional datasets: 
  Product dimension (with different level of category attributes, colour, age & gender flag - i.e. Clothing Male Audlt -rather than just Clothing )
  More Customer attributes (lifestage, address(suburb),fav store, etc )
  Browsing history/ Cart Details
- create a feature store at customer level - aggregating based on different dimensions.

2. Data Sharing: how would you implement PII on this data

- Step 1: Define PII data classifcation, example:
  Email -> PI
  customer_id -> tech_id
  subsurb -> pi_quasi
  order_id -> data 

- Step 2: Apply Hash (Sha2 Hash or Salt-hash) based on the pii data classification before sharing

- Step 3: internally, we can apply tagging & masking based the pii classification to further secure privacy
