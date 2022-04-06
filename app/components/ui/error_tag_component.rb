# frozen_string_literal: true

module UI
  class ErrorTagComponent < ViewComponent::Base
    def initialize(errors:, field:)
      @errors = errors
      @field = field
    end

    def render?
      @errors[@field].present?
    end
  end
end
