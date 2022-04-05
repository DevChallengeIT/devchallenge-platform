# frozen_string_literal: true

module UI
  class ChallengeStatusComponent < ViewComponent::Base
    COLOR_STATUS = {
      Repo::Challenge::DRAFT        => 'bg-gray-500',
      Repo::Challenge::MODERATION   => 'bg-orange-500',
      Repo::Challenge::PENDING      => 'bg-lime-500',
      Repo::Challenge::REGISTRATION => 'bg-cyan-500',
      Repo::Challenge::LIVE         => 'bg-green-500',
      Repo::Challenge::COMPLETE     => 'bg-indigo-500',
      Repo::Challenge::CANCELED     => 'bg-red-500'
    }.freeze

    def initialize(challenge:)
      @status = challenge.status
    end

    def status_classes
      COLOR_STATUS[@status]
    end
  end
end
