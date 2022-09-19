# frozen_string_literal: true

module Competition
  class SubmissionsQuery
    include ActiveRecord::Sanitization::ClassMethods

    def self.list_submissions(**params)
      new(**params).call
    end

    attr_reader :task, :search

    def initialize(task:, search: nil)
      @task = task
      @search = search
    end

    def call
      maybe_search
    end

    private

    def scope
      @scope ||= task.task_submissions.preload(:zip_file_blob, judge: :user, member: :user)
    end

    def maybe_search
      return scope if search.blank?

      sanitized_search = "%#{sanitize_sql_like(search)}%"
      scope.joins(member: :user).where('users.email LIKE ? OR users.full_name ILIKE ? OR users.phone_number LIKE ? ',
                                       sanitized_search, sanitized_search, sanitized_search)
    end
  end
end
