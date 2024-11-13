# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


#DOCKER

1. rails new myapp --database=postgresql
cd myapp

2. Make docker file in the root: Dockerfile

# Use the official Ruby image from the Docker Hub
FROM ruby:3.1.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable for the application's root directory
ENV RAILS_ROOT /var/www/myapp
RUN mkdir -p $RAILS_ROOT 
WORKDIR $RAILS_ROOT

# Set environment variables for the RAILS environment
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Install Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile assets and clear cache
RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clean

# Expose port 3000 to the Docker host, so we can access it
EXPOSE 3000

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]

3. Step 3: Create a docker-compose.yml File
Create a docker-compose.yml file in the root directory with the following content:

version: '3.8'
services:
  db:
    image: postgres:13
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: myapp_development

  web:
    build: .
    command: bundle exec rails s -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgres://postgres:password@db:5432/myapp_development

volumes:
  postgres_data:


4. config/database.yml

default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: postgres
  password: password
  host: db

development:
  <<: *default
  database: myapp_development

test:
  <<: *default
  database: myapp_test

production:
  <<: *default
  database: myapp_production
  username: myapp
  password: <%= ENV['MYAPP_DATABASE_PASSWORD'] %>


Step 5: Build and Run the Containers

Build the Docker image:
a. docker-compose build

Run the containers:
b. docker-compose up

Create the database:
c. docker-compose run web rake db:create

Run database migrations:
d. docker-compose run web rake db:migrate


6. For the console: docker-compose exec web rails console


Git and Bit repos

bitbucket https://rinkukushwah679@bitbucket.org/rinkukushwah679/docker-app.git (fetch)
bitbucket https://rinkukushwah679@bitbucket.org/rinkukushwah679/docker-app.git (push)
origin  https://github.com/rinkukushwah5679/docker-app.git (fetch)
origin  https://github.com/rinkukushwah5679/docker-app.git (push)