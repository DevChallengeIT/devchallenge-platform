# frozen_string_literal: true

module Admin
  class ChallengesController < BaseController
    helper_method :challenge

    def index
      @paginator, @challenges = paginate Repo::Challenge.all
    end

    def new
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
