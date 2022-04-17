# frozen_string_literal: true

module Repo
  class TaskSubmission < ApplicationRecord
    belongs_to :task
    belongs_to :member
    # TODO: add attachments

    validates :task, presence: true
    validates :member, presence: true
    validates :task, uniqueness: { scope: :member_id }
  end
end
