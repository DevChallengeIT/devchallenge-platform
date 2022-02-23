# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# CORE
gem 'devise', '~> 4.8'
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.2'

# Frontend
gem 'importmap-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'turbo-rails'

# Support
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Tools
gem 'friendly_id', '~> 5.4.0'

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
end
