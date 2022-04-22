# frozen_string_literal: true

module Repo
  class TaskAssessment < ApplicationRecord
    belongs_to :member
    belongs_to :task_submission
    belongs_to :task_criterium

    has_one :task, through: :task_submission

    validates :member, presence: true # TODO: only judge!
    validates :task_submission, presence: true, uniqueness: { scope: :member_id }
    validates :task_criterium, presence: true
    # TODO: can't be larger than task_criterium.max_value
  end
end
