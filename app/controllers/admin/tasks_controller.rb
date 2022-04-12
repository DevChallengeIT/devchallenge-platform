# frozen_string_literal: true

module Admin
  class TasksController < BaseController
    helper_method :task

    def index
      @paginator, @tasks = paginate Repo::Task.all
    end

    def new
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
      @tasks = task.challenge.tasks.where.not(id: task.id)
    end

    private

    def task
      @task ||= Repo::Task.friendly.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :slug, :registration_at, :challenge_id,
                                   :start_at, :submit_at, :result_at, :dependent_task_id, :min_assestment)
    end
  end
end
