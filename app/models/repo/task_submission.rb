# frozen_string_literal: true

module Repo
  class TaskSubmission < ApplicationRecord
    belongs_to :task
    belongs_to :member
    belongs_to :judge, class_name: 'Repo::Member', optional: true

    has_many :task_assessments, dependent: :destroy

    has_one_attached :zip_file

    accepts_nested_attributes_for :task_assessments

    validates :task, presence: true
    validates :member, presence: true
    validates :task, uniqueness: { scope: :member_id }
  end
end
