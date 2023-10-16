# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# CORE
gem 'devise', '~> 4.8.1'
gem 'omniauth-github', '~> 2.0'
gem 'omniauth-google-oauth2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
gem 'redis', '~> 5.0'
gem 'sidekiq', '~> 6.4.1'
gem 'sprockets-rails'

# Frontend
gem 'breadcrumbs_on_rails', '~> 4.1'
gem 'chartkick'
gem 'cssbundling-rails'
gem 'inline_svg'
gem 'jsbundling-rails'
gem 'pagy', '~> 5.10'
gem 'stimulus-rails', '~> 1.0'
gem 'tailwindcss-rails', '~> 2.0'
gem 'turbo-rails', '~> 1.0'
gem 'view_component', '~> 2.52'

# Support
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Tools
gem 'acts_as_list', '~> 1.0.4'
gem 'awesome_print', '~> 1.9'
gem 'aws-sdk-s3'
gem 'circular_array'
gem 'friendly_id', '~> 5.4.0'
gem 'groupdate'
gem 'image_processing'
gem 'lograge', '~> 0.12'
gem 'mailerlite', '~> 1.16'
gem 'newrelic_rpm', '~> 9.5'
gem 'rack-attack', '~> 6.7'
gem 'sentry-rails'
gem 'sentry-ruby'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'guard-rspec', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
  # gem "rack-mini-profiler"
end

group :test do
  gem 'capybara', '~> 3.36'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'ffaker', '~> 2.20'
  gem 'launchy'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.18'
end
