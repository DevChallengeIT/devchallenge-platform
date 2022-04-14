# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: Repo::Task.name do
    sequence(:title) { |n| "Task-#{n}" }
    start_at         { '2022-05-01 10:00:00' }
    submit_at        { '2022-05-10 18:00:00' }
    result_at        { '2022-05-11 09:00:00' }
    challenge
  end
end
