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
      @task = Repo::Task.new(task_params)

      if task.save
        redirect_to(edit_admin_challenge_task_path(challenge, task), notice: flash_message(:created, :tasks))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb task.title
      @tasks = task.challenge.tasks.where.not(id: task.id)
    end

    def update
      if task.update(task_params)
        redirect_to(admin_challenge_tasks_path(challenge), notice: flash_message(:updated, :tasks))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def challenge_tasks
      @challenge_tasks ||= Repo::Task.preload(:challenge).where(challenge:)
    end

    def challenge
      @challenge ||= Repo::Challenge.friendly.find(params[:challenge_id])
    end

    def task
      @task ||= Repo::Task.preload(:challenge).friendly.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :slug, :registration_at, :challenge_id,
                                   :start_at, :submit_at, :result_at, :dependent_task_id, :min_assestment)
    end
  end
end
