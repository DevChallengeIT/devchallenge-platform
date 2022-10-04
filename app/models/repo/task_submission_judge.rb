# frozen_string_literal: true

module Repo
  class TaskSubmissionJudge < ApplicationRecord
    belongs_to :task_submission
    belongs_to :judge, class_name: 'Repo::Member'
  end
end
