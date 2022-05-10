# frozen_string_literal: true

module UI
  class AssessmentsController < BaseController
    include CompetitionContext

    helper_method :task, :task_submission, :task_criteria, :task_assessments

    before_action :authenticate_user!

    def new
      task_criteria.each do |criterium|
        task_submission.task_assessments.build(task_criterium: criterium)
      end
    end

    def create
      if task_submission.update(task_assessment_params)
        redirect_to task_path(task), notice: flash_message(:created, :task_assessments)
      else
        # TODO: show errors
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if task_submission.update(task_assessment_params)
        redirect_to task_path(task), notice: flash_message(:updated, :task_assessments)
      else
        # TODO: show errors
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def task
      @task ||= task_submission.task
    end

    def task_criteria
      @task_criteria ||= task.task_criteria
    end

    def task_assessments
      @task_assessments ||= task_submission.task_assessments
    end

    def challenge
      @challenge ||= task.challenge
    end

    def task_submission
      @task_submission ||= Repo::TaskSubmission.preload(
        :zip_file_blob,
        task:             %i[challenge rich_text_description task_criteria],
        task_assessments: :task_criterium
      ).find(params[:task_submission])
    end

    def task_assessment_params
      @task_assessment_params ||= set_assessment_params
    end

    def set_assessment_params
      assessment_params = params.require(:task_assessments).permit(
        task_assessments_attributes: %i[id task_criterium_id value comment]
      )

      assessment_params[:task_assessments_attributes].each do |attributes|
        attributes.last[:member] = current_member
      end

      assessment_params
    end
  end
end
