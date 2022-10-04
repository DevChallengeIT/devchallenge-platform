# frozen_string_literal: true

FactoryBot.define do
  factory :task_submission_judge, class: Repo::TaskSubmissionJudge.name do
    task_submission
    association :judge, factory: :member
  end
end
