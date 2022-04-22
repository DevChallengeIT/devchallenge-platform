# frozen_string_literal: true

module UI
  class MembersController < BaseController
    include CompetitionContext

    before_action :authenticate_user!

    def create
      challenge.members.create(user: current_user)
      redirect_to challenge_path(challenge), notice: t('messages.challenge_joined')
    end

    def destroy
      current_member.destroy
      redirect_to challenge_path(challenge), notice: t('messages.challenge_leaved')
    end
  end
end
