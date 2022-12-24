# syntax=docker/dockerfile:1
FROM ruby:3.1.1

ENV RAILS_ENV production

RUN apt-get update -qq && apt-get install -y vim nodejs postgresql-client nginx yarn

WORKDIR /devchallenge
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY app ./app
COPY config ./config
COPY db ./db
COPY lib ./lib
COPY public ./public
COPY storage ./storage
COPY vendor ./vendor
COPY config.ru .
COPY package*json .
COPY Rakefile .

RUN gem install bundler -v 2.3.10
RUN bundle install --full-index --jobs 4
RUN yarn install --frozen-lockfile

COPY nginx.${RAILS_ENV}.conf /etc/nginx/sites-enabled/default
COPY nginx.${RAILS_ENV}.conf /etc/nginx/sites-available/default

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
CMD rails server -b 0.0.0.0 -p 3000
