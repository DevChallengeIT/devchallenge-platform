# frozen_string_literal: true

module Admin
  class MembersController < BaseController
    helper_method :challenge, :member

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb I18n.t('resources.members.plural'), :admin_challenge_members_path

    def index
      @paginator, @members = paginate challenge_members
    end

    def edit
      add_breadcrumb member.user.email
    end

    def update
      if member.update(member_params)
        redirect_to(admin_challenge_members_path(challenge), notice: flash_message(:updated, :member))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      member.destroy
      redirect_to(admin_challenge_members_path, notice: flash_message(:removed, :member))
    end

    private

    def challenge
      @challenge ||= Repo::Challenge.friendly.find(params[:challenge_id])
    end

    def challenge_members
      @challenge_members ||= Repo::Member.preload(:user).where(challenge:)
    end

    def member
      @member ||= Repo::Member.preload(:user).find(params[:id])
    end

    def member_params
      params.require(:member).permit(:role)
    end
  end
end
