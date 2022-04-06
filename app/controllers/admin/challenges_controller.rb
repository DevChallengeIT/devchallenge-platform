# frozen_string_literal: true

module Admin
  class ChallengesController < BaseController
    helper_method :challenge

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path

    def index
      @paginator, @challenges = paginate Repo::Challenge.all
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @challenge = Repo::Challenge.new
    end

    def create
      @challenge = Repo::Challenge.new(challenge_params)

      if challenge.save
        redirect_to(edit_admin_challenge_path(challenge), notice: flash_message(:created, :challenges))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb challenge.title
    end

    def update
      if challenge.update(challenge_params)
        redirect_to(admin_challenges_path, notice: flash_message(:updated, :challenges))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def challenge
      @challenge ||= Repo::Challenge.friendly.find(params[:id])
    end

    def challenge_params
      params.require(:challenge).permit(:status, :title, :description, :terms_and_conditions, :slug, :registration_at,
                                        :start_at, :finish_at)
    end
  end
end
