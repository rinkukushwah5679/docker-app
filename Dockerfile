# Use the official Ruby image from the Docker Hub
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set an environment variable for the application's root directory
ENV RAILS_ROOT /docker-myapp
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
