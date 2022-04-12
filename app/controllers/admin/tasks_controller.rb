# frozen_string_literal: true

module Admin
  class TasksController < BaseController
    def index
      @paginator, @tasks = paginate Repo::Task.all
    end

    def new
      @task = Repo::Task.new
    end
  end
end
