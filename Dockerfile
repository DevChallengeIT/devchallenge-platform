# syntax=docker/dockerfile:1
FROM ruby:3.1.1

ENV RAILS_ENV staging

RUN apt-get update -qq && apt-get install -y vim nodejs postgresql-client nginx

WORKDIR /devchallenge
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# Install gems
RUN bundle install --full-index --jobs 4 --without development test

COPY app ./app
COPY config ./config
COPY db ./db
COPY lib ./lib
COPY public ./public
COPY storage ./storage
COPY vendor ./vendor
COPY config.ru .

COPY nginx.${RAILS_ENV}.conf /etc/nginx/sites-enabled/default
COPY nginx.${RAILS_ENV}.conf /etc/nginx/sites-available/default

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD rails server -b 0.0.0.0 -p 3000
