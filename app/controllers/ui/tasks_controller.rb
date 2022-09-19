# frozen_string_literal: true

module UI
  class TasksController < BaseController
    include CompetitionContext

    before_action :authenticate_user!, :authorize_member!
    before_action :authorize_member_for_task!, only: :show
    helper_method :task, :task_submission, :task_submissions, :get_judge_assesment

    def show
      if current_member&.judge?
        render 'ui/tasks/judges/show'
      else
        @result = Competition::TasksAssessmentCalculator.total_assessment_for(
          participant: current_member,
          task:
        )

        super
      end
    end

    private

    def authorize_member_for_task!
      return true if user_authorized_for_task?(task)

      redirect_to root_path, alert: t('messages.access_denied')
    end

    def challenge
      @challenge ||= task&.challenge
    end

    def task
      @task ||= Repo::Task.preload(
        :rich_text_description,
        :dependent_task,
        :dependency,
        challenge: :members
      ).friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def task_submission
      @task_submission ||= task.task_submissions.find_by(member: current_member) || Repo::TaskSubmission.new
    end

    def task_submissions
      @task_submissions ||= task
                            .task_submissions
                            .preload(:task_assessments, :zip_file_blob, member: :user)
                            .where(judge_id: [nil, current_member&.id])
    end

    def get_judge_assesment(task_assessments)
      result = task_assessments.select do |ta|
        ta.judge_id == current_member.id
      end.map(&:value).sum.to_f / task_assessments.select do |ta|
                                    ta.judge_id == current_member.id
                                  end.count
      result.nan? ? 'Pending' : result.round(2)
    end
  end
end
