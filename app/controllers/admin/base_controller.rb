# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate_user!
    before_action :authenticate_admin!

    add_breadcrumb I18n.t('words.dashboard'), :admin_root_path, unless: :dashboard_controller?

    private

    def authenticate_admin!
      return if Auth.admin?(current_user)

      redirect_to root_path, alert: t('messages.access_denied')
    end

    def dashboard_controller?
      controller_name == 'dashboard'
    end
  end
end
