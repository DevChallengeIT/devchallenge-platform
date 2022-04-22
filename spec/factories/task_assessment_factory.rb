# frozen_string_literal: true

FactoryBot.define do
  factory :task_assessment, class: Repo::TaskAssessment.name do
    member
    task_submission
    task_criterium
  end
end
