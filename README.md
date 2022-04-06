# README

## Setup development env

Required
- Ruby 3.1
- Postgres
- Redis

1. Setup
```sh
gem install bundler
bundle install
rails db:create
rails db:migrate
rails db:seed
```

2. Test & Lint
```sh
rspec
rubocop
```

3. Dev server
```sh
./bin/dev
```
or
```sh
bin/rails server -p 3000
bin/rails tailwindcss:watch
```