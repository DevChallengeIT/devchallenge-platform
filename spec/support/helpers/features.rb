# frozen_string_literal: true

module SpecHelpers
  module Features
    attr_reader :current_user

    def assume_logged_in(user = nil, admin: false)
      user ||= user || admin ? create(:user, :admin) : create(:user)
      @current_user = user

      login_as(user)
    end
  end
end
