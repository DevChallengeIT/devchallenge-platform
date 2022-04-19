# frozen_string_literal: true

module Repo
  class TaskAssessment < ApplicationRecord
    belongs_to :member
    belongs_to :task_submission
    belongs_to :task_criteria

    has_one :task, through: :task_submission

    validates :member, presence: true
    validates :task_submission, presence: true, uniqueness: { scope: :member_id }
    validates :task_criteria, presence: true
  end
end
