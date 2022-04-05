# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :within_time_zone, if: :current_user

  private

  def flash_message(action, resource_name)
    t("messages.resource_#{action}", name: t("resources.#{resource_name}.singular"))
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name time_zone])
  end

  def within_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
