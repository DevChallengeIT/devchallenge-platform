# frozen_string_literal: true

module Users
  class UsersQuery
    include ActiveRecord::Sanitization::ClassMethods

    def self.list_users(**params)
      new(**params).call
    end

    attr_reader :search

    def initialize(search: nil)
      @search = search
    end

    def call
      maybe_search
    end

    private

    def scope
      @scope ||= Repo::User.all
    end

    def maybe_search
      return scope if search.blank?

      sanitized_search = "%#{sanitize_sql_like(search)}%"
      scope.where(
        'users.legacy_id LIKE ? OR users.email LIKE ? OR users.full_name ILIKE ? OR users.phone_number LIKE ? ',
        sanitized_search,
        sanitized_search,
        sanitized_search,
        sanitized_search
      )
    end
  end
end
