# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# CORE
gem 'devise', '~> 4.8.1'
gem 'pg', '~> 1.1'
gem 'propshaft', '~> 0.6'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.2'
gem 'redis', '~> 4.6.0'
gem 'sidekiq', '~> 6.4.1'

# Frontend
gem 'breadcrumbs_on_rails', '~> 4.1'
gem 'importmap-rails', '~> 1.0'
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
gem 'friendly_id', '~> 5.4.0'
gem 'lograge', '~> 0.12'

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
end
