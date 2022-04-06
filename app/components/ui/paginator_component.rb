# frozen_string_literal: true

module UI
  class PaginatorComponent < ViewComponent::Base
    include Pagy::Frontend

    def initialize(paginator:)
      @paginator = paginator
    end

    def render?
      @paginator&.next.present?
    end
  end
end
