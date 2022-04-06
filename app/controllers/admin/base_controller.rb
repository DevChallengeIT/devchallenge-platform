# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate_user!
    before_action :authenticate_admin!

    private

    def authenticate_admin!
      return if Auth.admin?(current_user)

      redirect_to root_path, alert: t('messages.access_denied')
    end
  end
end
