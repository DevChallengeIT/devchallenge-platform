# frozen_string_literal: true

module Auth
  extend self

  ADMIN_USERS = Rails
                .application
                .credentials
                .admin_users
                .split(',')
                .index_with { |_email| true }
                .freeze

  def admin?(user)
    return false unless user

    ADMIN_USERS[user.email].present?
  end
end
