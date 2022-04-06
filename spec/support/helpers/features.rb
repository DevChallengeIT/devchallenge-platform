# frozen_string_literal: true

module SpecHelpers
  module Features
    attr_reader :current_user

    def assume_logged_in(user = nil, admin: false)
      local_user = if user
                     user
                   else
                     admin ? create(:user, :admin) : create(:user)
                   end

      @current_user = local_user

      login_as(local_user)
    end
  end
end
