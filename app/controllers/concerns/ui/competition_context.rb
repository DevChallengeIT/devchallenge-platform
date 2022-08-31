# frozen_string_literal: true

module UI
  module CompetitionContext
    extend ActiveSupport::Concern

    included do
      helper_method :challenge, :current_member, :user_authorized_for_task?
      before_action :authorize_challenge!, only: :show
    end

    def show; end

    def challenge
      @challenge ||= Repo::Challenge.preload(
        :rich_text_description,
        :rich_text_terms_and_conditions,
        :members
      ).friendly.find(params[:challenge_id] || params[:id])
    end

    def current_member
      @current_member ||= challenge.members.find_by(user: current_user)
    end

    def authorize_challenge!
      return true if challenge && Competition.can_read?(user: current_user, challenge:)

      redirect_to root_path, alert: t('messages.access_denied')
    end

    def authorize_member!
      return true if current_member || Auth.admin?(current_user)

      redirect_to root_path, alert: t('messages.access_denied')
    end

    def authorize_judge!
      redirect_to root_path, alert: t('messages.access_denied') unless current_member&.judge?
    end

    def user_authorized_for_task?(task)
      Competition.can_user_do_task?(user: current_user, task:)
    end
  end
end
