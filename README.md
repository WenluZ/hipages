This project is intended as an exercise for Analytics Engineering roles. 

It focuses on **Customer 360** (or **Single Customer View**): a unified view of customer interactions that powers use cases ranging from personalized recommendations to customer segmentation.  

### Pre-requisites

The project assumes these tools are available:

+ Makefile
+ Python 3.9+ ([python.org](https://www.python.org/downloads/), [Anaconda](https://www.anaconda.com/download), [pyenv](https://github.com/pyenv/pyenv) etc)
+ Docker, Docker Compose (https://www.docker.com/products/docker-desktop/)

You'd likely need a Postgres client to see what models look like. Here's [one](https://dbeaver.io/).

### Development

The `integration_tests` directory is set up to work through this exercise, including:
+ starting a Postgres container and seeding it with fake data
+ running models and tests included in the parent package (see [packages.yml](./integration_tests/packages.yml), [profiles.yml](./integration_tests/profiles.yml))
+ tear down
+ a `Makefile` for running the above tasks (try `make help`)

---

Follow these steps (assumes you are in `integration_tests` directory):

1. Set up Python virtual environment and install dependencies (including DBT + Postgres adaptor):
```sh
$> python -m venv venv
$> source venv/bin/activate
$> pip install -r requirements.txt
```

2. Start database and populate with sample datasets: 
```sh
$> make setup
```

3. Run and test models using DBT
```sh
$> make models
```

4. Tear down (will destroy the DB container)
```sh
$> make teardown
```

### Exercises

Responses/solutions to these exercises can be:
+ code changes
+ [seed data](./integration_tests/seeds/) changes
+ free-form text (eg. assumptions, opinions, approaches etc) - these can be submitted in email, markdown etc. as long as they clearly refer to the exercise they refer to.

Please create a git repository for this code and share it with us (a link or a [bundle](https://git-scm.com/book/en/v2/Git-Tools-Bundling)) - we'd like to look at your commit logs too :).

---

*Note*: any code changes will need a re-run of `dbt deps` in `integration_tests` directory.

Please attempt as many of these as possible:
1. Fix the failing tests

2. Add a test to validate the referential integrity of the `transactions` table (`contact_id` refers to a valid contact) and ensure it passes

3. We want to ensure our `transactions` data is not older than 1 day. How to do this and when to run these checks?

4. Add tests for macros

5. Macros contain Postgres-specific functions, however our production environment is in Databricks. How would you refactor them, to allow switching between these two syntax?

6. We'd like to enhance the `customers` model by adding few more attributes:
   + `first_purchase_date` and `last_purchase_date` (time of first and last purchase respectively)
   + total amount of purchase per category eg. columns like `app_and_games_amount`, `beauty_amount` etc. (refer to `_web__sources.yml` for a static list of product categories)
   
   Please update the `customers` model for these columns. Also, write singular test(s) to validate the logic.

7. Any other improvements you'd like to make?

8. Think of how you can implement the following (what additional datasets would you use, how will the models look etc). We will explore these add-ons during tech interview stage. Additional points, if you can implement them now!
   + Product Category Recommender - how to implement Next Best Product Category?
   + Data Sharing: how would you implement PII on this data, so it can be safely shared with, say, partners?


