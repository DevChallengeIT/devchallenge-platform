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

#### Run docker container locally

Run all commands in the app folder

1. build docker image
```sh
docker build -t devchallenge-platform_web:latest .
```
2. run docker containers
```sh
docker compose up
```
or start DB in detached mode
```sh
docker compose up -d db
```
and attached rails server
```sh
docker compose up web
```
