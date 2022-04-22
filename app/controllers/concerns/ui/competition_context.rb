# frozen_string_literal: true

module UI
  module CompetitionContext
    extend ActiveSupport::Concern

    included do
      helper_method :challenge, :current_member
      before_action :authorize_challenge, only: :show
    end

    def show; end

    def challenge
      @challenge ||= Repo::Challenge.friendly.find(params[:challenge_id] || params[:id])
    end

    def current_member
      @current_member ||= challenge.members.find_by(user: current_user)
    end

    def authorize_challenge
      return true if Competition.can_read?(user: current_user, challenge:)

      redirect_to root_path, notice: t('messages.access_denied')
    end
  end
end
