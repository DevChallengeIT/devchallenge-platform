# frozen_string_literal: true

module Users
  class MembersQuery
    include ActiveRecord::Sanitization::ClassMethods

    def self.list_members(**params)
      new(**params).call
    end

    attr_reader :challenge, :search

    def initialize(challenge:, search: nil)
      @challenge = challenge
      @search = search
    end

    def call
      maybe_search
    end

    private

    def scope
      @scope ||= Repo::Member.where(challenge:).preload(:user)
    end

    def maybe_search
      return scope if search.blank?

      sanitized_search = "%#{sanitize_sql_like(search)}%"
      scope.joins(:user).where('users.email LIKE ? OR users.full_name ILIKE ? OR users.phone_number LIKE ? ',
                               sanitized_search, sanitized_search, sanitized_search)
    end
  end
end
