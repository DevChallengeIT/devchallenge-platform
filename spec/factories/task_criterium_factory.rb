# frozen_string_literal: true

FactoryBot.define do
  factory :task_criterium, class: Repo::TaskCriterium.name do
    sequence(:title) { |n| "TaskCriterium-#{n}" }
    max_value { 10 }
    task
  end
end
