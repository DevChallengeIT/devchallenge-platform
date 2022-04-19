# frozen_string_literal: true

module Repo
  class TaskAssessment < ApplicationRecord
    belongs_to :member
    belongs_to :task_submission
    belongs_to :task, through: :task_submission

    has_one :task_criteria
  end
end
