# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def new
    tracker do |t|
      t.facebook_pixel :track, { type: 'InitiateCheckout' }
    end

    super
  end

  def create
    tracker do |t|
      t.facebook_pixel :track, { type: 'InitiateCheckout' }
    end

    super
  end

  protected

  def after_sign_up_path_for(_resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params['password']&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except('current_password'))
  end
end
