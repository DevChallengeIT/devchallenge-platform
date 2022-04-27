# frozen_string_literal: true

module Admin
  class MembersController < BaseController
    helper_method :challenge, :member, :roles

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.members.plural'), :admin_challenge_members_path

    def index
      @paginator, @members = paginate challenge_members
    end

    def edit
      add_breadcrumb member.user.email
    end

    def update
      if member.update(member_params)
        redirect_to(admin_challenge_members_path(challenge),
                    notice: flash_message(:updated, :members))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      member.destroy
      redirect_to(admin_challenge_members_path,
                  notice: flash_message(:removed, :members))
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

    def roles
      Repo::Member.roles.except(member.role)
    end
  end
end
