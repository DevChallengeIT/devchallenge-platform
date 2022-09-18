# frozen_string_literal: true

module Users
  extend self

  delegate :list_users, to: UsersQuery
  delegate :list_members, to: MembersQuery
end
