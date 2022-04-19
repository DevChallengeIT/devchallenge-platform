# frozen_string_literal: true

FactoryBot.define do
  factory :task_submission, class: Repo::TaskSubmission.name do
    member
    task
  end
end
