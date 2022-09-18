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

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # TODO: Extract to separate service file
  def omniauth(auth)
    Repo::User.where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.provider = auth.provider
      user.full_name = auth.info.name
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  rescue ActiveRecord::RecordInvalid
    user = Repo::User.where(email: auth.info.email).where.not(legacy_id: nil).first_or_initialize
    user.full_name = auth.info.name
    user.provider = auth.provider
    user.uid = auth.uid
    user.password = Devise.friendly_token[0, 20]
    user.save
    user
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
