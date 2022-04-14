# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Repo::Task.name do
    sequence(:title) { |n| "Task-#{n}" }
    challenge
  end
end
