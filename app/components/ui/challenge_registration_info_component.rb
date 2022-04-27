# frozen_string_literal: true

module UI
  class ChallengeRegistrationInfoComponent < ViewComponent::Base
    def initialize(challenge:)
      @challenge = Competition::ChallengePolicy.new(user: nil, challenge:)
    end

    def registration_info
      if @challenge.registration_closed?
        t('messages.challenge_registration_closed')
      elsif @challenge.registration_not_started?
        t('messages.challenge_registration_not_opened_yet')
      else
        t('messages.register_to_join')
      end
    end
  end
end
