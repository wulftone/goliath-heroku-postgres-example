Attempting to get Goliath to work with Postgres and Heroku

Once the app is deployed to heroku, you need to run `heroku run rake create_db` to create an empty database.
This assumes that you have a 'shared database' heroku addon already.
