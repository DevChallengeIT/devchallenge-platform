# frozen_string_literal: true

module Admin
  class TasksController < BaseController
    helper_method :task

    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_tasks_path

    def index
      @paginator, @tasks = paginate Repo::Task.preload(:challenge).all
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @task = Repo::Task.new
    end

    def create
      @task = Repo::Task.new(task_params)

      if task.save
        redirect_to(edit_admin_task_path(task), notice: flash_message(:created, :tasks))
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
        redirect_to(admin_tasks_path, notice: flash_message(:updated, :tasks))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def task
      @task ||= Repo::Task.preload(:challenge).friendly.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :slug, :registration_at, :challenge_id,
                                   :start_at, :submit_at, :result_at, :dependent_task_id, :min_assestment)
    end
  end
end
