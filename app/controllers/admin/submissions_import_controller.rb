# frozen_string_literal: true

module Admin
  class SubmissionsImportController < BaseController
    helper_method :challenge, :task, :judges

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path
    add_breadcrumb(proc { |ctx| ctx.task.title }, proc { |ctx|
                                                    ctx.edit_admin_challenge_task_path(ctx.challenge, ctx.task)
                                                  })
    add_breadcrumb I18n.t('words.import')

    def create
      import_params[:emails].split(/\n/).each do |email|
        member = Repo::Member.joins(:user).where(challenge:).where(users: { email: email.chomp }).first

        next unless member

        Repo::TaskSubmission.create(
          task:,
          member:,
          judge_id: import_params[:judge_id]
        )
      end
      redirect_to admin_challenge_task_submissions_path(challenge, task), notice: 'Import has been successful'
    rescue StandardError => e
      flash[:error] = e.message
      render :new
    end

    private

    def import_params
      params.require(:import).permit(:emails, :judge_id).compact_blank
    end

    def task
      @task ||= Repo::Task.preload(:challenge).friendly.find(params[:task_id])
    end

    def challenge
      @challenge ||= task.challenge
    end

    def judges
      @judges ||= challenge.members.judge.preload(:user)
    end
  end
end
