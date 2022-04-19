# frozen_string_literal: true

module Admin
  class TaskSubmissionsController < BaseController
    helper_method :task, :task_submission, :member

    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_tasks_path
    add_breadcrumb I18n.t('resources.task_submissions.plural'), :admin_task_submissions_path

    def index
      @paginator, @task_submissions = paginate task.task_submissions.preload(member: :user)
    end

    def destroy
      task_submission.destroy
      redirect_to(admin_task_submissions_path(task), notice: flash_message(:removed, :task_submissions))
    end

    private

    def task_submission
      @task_submission ||= task.task_submissions.find(params[:id])
    end

    def task
      @task ||= Repo::Task.friendly.preload(:challenge).find(params[:task_id])
    end
  end
end