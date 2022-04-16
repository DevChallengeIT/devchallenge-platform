# frozen_string_literal: true

module Admin
  class JudgesController < BaseController
    add_breadcrumb I18n.t('resources.judges.plural'), :admin_judges_path

    def index
      @paginator, @judges = paginate Repo::Member.preload(:user, :challenge).all.judge
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @judge = Repo::Member.new
    end

    def create
      @judge = Repo::Member.new(judge_params)

      if @judge.save
        redirect_to(admin_judges_path, notice: flash_message(:created, :judges))
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def judge_params
      params.require(:judge).permit(:user_id, :challenge_id).merge(role: :judge)
    end
  end
end
