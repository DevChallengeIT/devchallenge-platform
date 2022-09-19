# frozen_string_literal: true

module Admin
  class SubmissionsController < BaseController
    helper_method :task, :task_submission, :challenge, :task_criterium, :judges, :members

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path
    add_breadcrumb(proc { |ctx| ctx.task.title }, proc { |ctx|
                                                    ctx.edit_admin_challenge_task_path(ctx.challenge, ctx.task)
                                                  })
    add_breadcrumb I18n.t('resources.task_submissions.plural'), :admin_challenge_task_submissions_path

    def index
      @paginator, @task_submissions = paginate Competition.list_submissions(task:, search: params[:search])
    end

    def new
      @task_submission = Repo::TaskSubmission.new
    end

    def create
      @task_submission = Repo::TaskSubmission.new(task_submission_params.merge(task_id: task.id))

      if task_submission.save
        redirect_to admin_challenge_task_submissions_path(challenge, task)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      task_submission.update(task_submission_params)
      redirect_to admin_challenge_task_submissions_path(challenge, task)
    end

    def destroy
      task_submission.destroy
      redirect_to(admin_challenge_task_submissions_path(challenge, task),
                  notice: flash_message(:removed, :task_submissions))
    end

    private

    def task_submission_params
      params.require(:task_submission).permit(:judge_id, :member_id, :notes, :zip_file)
    end

    def task_submission
      @task_submission ||= task.task_submissions.find(params[:id] || params[:task_submission_id])
    end

    def task_criterium
      # TODO: change it
      # @task_criterium ||= task.task_criteria.find(params[:id])
      @task_criterium ||= task.task_criteria.first
    end

    def task
      @task ||= Repo::Task.friendly.preload(:challenge, :task_submissions).find(params[:task_id])
    end

    def challenge
      @challenge ||= task.challenge
    end

    def judges
      @judges ||= challenge.members.judge.preload(:user)
    end

    def members
      @members ||= challenge.members.participant.preload(:user).where.not(id: task.member_ids)
    end
  end
end
