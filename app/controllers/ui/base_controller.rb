# frozen_string_literal: true

module UI
  class BaseController < ApplicationController
    def append_info_to_payload(payload)
      super

      payload[:user_id] = current_user&.id
    rescue StandardError
      payload
    end
  end
end
