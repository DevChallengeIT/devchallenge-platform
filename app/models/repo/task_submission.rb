# frozen_string_literal: true

module Repo
  class TaskSubmission < ApplicationRecord
    belongs_to :task
    belongs_to :member

    has_one :task_assessment, required: false

    has_one_attached :zip_file

    validates :task, presence: true
    validates :member, presence: true
    validates :task, uniqueness: { scope: :member_id }
  end
end
