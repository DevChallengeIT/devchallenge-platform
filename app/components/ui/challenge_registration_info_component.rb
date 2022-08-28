# frozen_string_literal: true

module UI
  class ChallengeRegistrationInfoComponent < ViewComponent::Base
    def initialize(challenge:, user: nil)
      @policy = Competition::ChallengePolicy.new(user:, challenge:)
      @user = user
      @challenge = challenge
      @status, @message = registration_info
    end

    private

    def registration_info
      if @policy.registration_closed?
        ['bg-red-500', t('messages.challenge_registration_closed')]
      elsif @policy.registration_not_started?
        ['bg-blue-500', t('messages.challenge_registration_not_opened_yet')]
      else
        ['bg-gray-500', t('messages.register_to_join')]
      end
    end
  end
end
