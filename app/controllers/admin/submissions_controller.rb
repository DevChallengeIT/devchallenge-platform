# frozen_string_literal: true

module Admin
  class SubmissionsController < BaseController
    helper_method :task, :task_submission, :challenge, :task_criterium

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path
    add_breadcrumb I18n.t('resources.task_submissions.plural'), :admin_challenge_task_submissions_path

    def index
      @paginator, @task_submissions = paginate task.task_submissions.preload(member: :user)
    end

    def destroy
      task_submission.destroy
      redirect_to(admin_challenge_task_submissions_path(challenge, task),
                  notice: flash_message(:removed, :task_submissions))
    end

    private

    def task_submission
      @task_submission ||= task.task_submissions.find(params[:id])
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
  end
end
