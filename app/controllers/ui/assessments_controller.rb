# frozen_string_literal: true

module UI
  class AssessmentsController < BaseController
    include CompetitionContext

    helper_method :task, :task_submission, :task_criteria, :task_assessments

    before_action :authenticate_user!

    def new
      @task_assessment = Repo::TaskAssessment.new
    end

    def create
      @task_assessment = Repo::TaskAssessment.new(
        task_assessment_params.merge(member: current_member, task_criterium: task_criteria.first, task_submission:)
      )

      if @task_assessment.save
        redirect_to task_path(task), notice: flash_message(:updated, :task_assessments)
      else
        redirect_to task_path(task), status: :unprocessable_entity
      end
    end

    def edit
      @task_assessment = task_submission.task_assessments.first
    end

    def update
      @task_submission = task_assessment.task_submission
      if @task_assessment.update(task_assessment_params)
        redirect_to task_path(task), notice: flash_message(:updated, :task_assessments)
      else
        redirect_to task_path(task), status: :unprocessable_entity
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

    def task_assessment
      @task_assessment ||= Repo::TaskAssessment.find(params[:id])
    end

    def challenge
      @challenge ||= task.challenge
    end

    def task_submission
      @task_submission ||= Repo::TaskSubmission.preload(:task_assessments,
                                                        task: %i[challenge
                                                                 task_criteria]).find(params[:task_submission])
    end

    def task_assessment_params
      params.require(:task_assessment).permit(:value, :comment)
    end
  end
end
