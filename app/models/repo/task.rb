# frozen_string_literal: true

module Repo
  class Task < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    has_rich_text :description

    belongs_to :challenge
    belongs_to :dependent_task, class_name: 'Repo::Task', optional: true

    has_one :dependency, class_name: 'Repo::Task', foreign_key: :dependent_task_id, dependent: :destroy_async,
inverse_of: :dependent_task

    has_many :task_criteria, dependent: :destroy_async
    has_many :task_submissions, dependent: :destroy_async
    has_many :task_assessments, through: :task_submissions, dependent: :destroy_async
    has_many :members, through: :task_submissions, dependent: :destroy_async

    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: true, scope: :challenge_id }
    validates :slug, presence: true, if: :persisted?
    validates :slug, uniqueness: { case_sensitive: true, scope: :challenge_id }

    validates :start_at, comparison: { less_than: :result_at }, allow_nil: true, if: :result_at
    validates :submit_at, comparison: { greater_than: :start_at }, allow_nil: true, if: :start_at
    validates :result_at, comparison: { greater_than: :submit_at }, allow_nil: true, if: :start_at
  end
end
