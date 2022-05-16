# frozen_string_literal: true

module Users
  extend self

  delegate :list_users, to: ListQuery
end
