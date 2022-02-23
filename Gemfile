source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"

# CORE
gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

# Frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Support
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 5.0.0'

end

group :development do
  gem "web-console"
  # gem "rack-mini-profiler"
end

group :test do
  gem 'capybara', '~> 3.36'
end
