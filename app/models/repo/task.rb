# frozen_string_literal: true

module Repo
  class Task < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :challenge
    belongs_to :dependent_task, class_name: 'Repo::Task', optional: true

    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: true }
    validates :slug, presence: true, if: :persisted?
    validates :slug, uniqueness: true, if: :persisted?

    validates :start_at, comparison: { less_than: :result_at }, allow_nil: true, if: :result_at
    validates :submit_at, comparison: { less_than: :start_at }, allow_nil: true, if: :start_at
    validates :result_at, comparison: { greater_than: :start_at }, allow_nil: true, if: :start_at
  end
end