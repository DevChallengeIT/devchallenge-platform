# frozen_string_literal: true

module Admin
  class CriteriaController < BaseController
    helper_method :task, :criterium

    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_tasks_path
    add_breadcrumb I18n.t('resources.criteria.plural'), :admin_task_criteria_path

    def index
      @paginator, @criteria = paginate task_criteria
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @criterium = Repo::TaskCriterium.new
    end

    def create
      @criterium = Repo::TaskCriterium.new(criterium_params.merge(task_id: task.id))

      if criterium.save
        redirect_to(admin_task_criteria_path(task), notice: flash_message(:created, :criteria))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb task.title
    end

    def update
      if criterium.update(criterium_params)
        redirect_to(admin_task_criteria_path(task),
                    notice: flash_message(:updated, :criteria))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      criterium.destroy
      redirect_to(admin_task_criteria_path,
                  notice: flash_message(:removed, :criteria))
    end

    private

    def task
      @task ||= Repo::Task.friendly.find(params[:task_id])
    end

    def task_criteria
      @task_criteria ||= Repo::TaskCriterium.preload(:task).where(task:)
    end

    def criterium
      @criterium ||= Repo::TaskCriterium.find(params[:id])
    end

    def criterium_params
      params.require(:criterium).permit(:title, :max_value)
    end
  end
end
