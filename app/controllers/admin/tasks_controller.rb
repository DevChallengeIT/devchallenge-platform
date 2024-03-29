# frozen_string_literal: true

module Admin
  class TasksController < BaseController
    helper_method :task, :challenge

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.edit_admin_challenge_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path

    def index
      @paginator, @tasks = paginate challenge_tasks
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @task = Repo::Task.new
    end

    def create
      @task = Repo::Task.new(task_params.merge(challenge_id: challenge.id))

      if task.save
        redirect_to(edit_admin_challenge_task_path(challenge, task), notice: flash_message(:created, :tasks))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb task.title
    end

    def update
      if task.update(task_params)
        redirect_to(edit_admin_challenge_task_path(challenge, task), notice: flash_message(:updated, :tasks))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      task.destroy
      redirect_to(admin_challenge_tasks_path(challenge), notice: flash_message(:removed, :tasks))
    rescue ActiveRecord::InvalidForeignKey
      redirect_to(edit_admin_challenge_task_path(challenge, task),
                  alert: 'Task can not be removed as it has dependent tasks or submissions')
    end

    private

    def challenge_tasks
      @challenge_tasks ||= Repo::Task.preload(:challenge, :dependent_task,
                                              :rich_text_description).where(challenge:).order(:start_at)
    end

    def challenge
      @challenge ||= Repo::Challenge.preload(:tasks).friendly.find(params[:challenge_id])
    end

    def task
      @task ||= challenge_tasks.friendly.find(params[:id])
    end

    def task_params
      params.require(:task).permit(
        :title, :description, :slug, :registration_at, :challenge_id, :start_at, :submit_at,
        :result_at, :dependent_task_id, :min_assessment, :require_attachment, :show_instant_result
      )
    end
  end
end
