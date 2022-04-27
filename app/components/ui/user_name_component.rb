# frozen_string_literal: true

module UI
  class UserNameComponent < ViewComponent::Base
    def initialize(user:)
      @user = user
    end
  end
end
