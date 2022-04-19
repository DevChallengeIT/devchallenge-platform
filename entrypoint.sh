#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /devchallenge/tmp/pids/server.pid

# Precompile assets
bundle exec rails assets:precompile

# Prepare database
bundle exec rails db:create db:schema:load db:migrate db:seed

# Start nginx server
service nginx restart

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
