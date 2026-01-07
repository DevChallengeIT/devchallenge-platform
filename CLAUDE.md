# DevChallenge Platform

## Project Overview
A Ruby on Rails platform for managing developer challenges and competitions.

## Tech Stack
- Ruby 3.4.5
- Rails 7.2.3
- PostgreSQL
- Redis
- Sidekiq for background jobs
- Tailwind CSS for styling
- Stimulus.js and Turbo for frontend interactivity

## Development Setup

### Prerequisites
- Ruby 3.4.5 (use mise: `mise use ruby@3.4.5`)
- PostgreSQL
- Redis

### Installation
```bash
bundle install
rails db:setup
```

### Running the Application
```bash
bin/dev
```

### Running Tests
```bash
bundle exec rspec
```

## Testing Guidelines
- Use meaningful variable names that describe the object's purpose or state (e.g., `challenge_old`, `challenge_new` instead of `challenge_a`, `challenge_b`)

## Key Dependencies
- Devise for authentication
- OmniAuth (GitHub, Google) for OAuth
- Pagy for pagination
- ViewComponent for UI components
- FriendlyId for slugs
- ActiveStorage with AWS S3

## Directory Structure
```
app/
├── components/     # ViewComponent components
├── controllers/
├── models/
├── views/
├── jobs/          # Sidekiq jobs
└── services/      # Service objects
```

## Common Commands
```bash
rails console      # Start Rails console
rails db:migrate   # Run migrations
bundle exec sidekiq # Start Sidekiq worker
```
