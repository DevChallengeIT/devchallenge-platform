# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: Repo::User.name do
    sequence(:email) { |n| "test-user-#{n}@devchallenge.it" }
    full_name { 'Test User' }
    password { 'password' }
  end
end
