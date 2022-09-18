# frozen_string_literal: true

module Repo
  class TaskAssessment < ApplicationRecord
    belongs_to :judge, class_name: 'Repo::Member'
    belongs_to :task_submission
    belongs_to :task_criterium

    has_one :task, through: :task_submission

    validates :value, presence: true
    validate :within_task_criterium_range?

    scope :by_judge, ->(judge) { where(judge_id: judge.id) }

    def within_task_criterium_range?
      errors.add(:value, :larger_than_max_value) if task_criterium&.max_value && value > task_criterium.max_value
    end
  end
end
