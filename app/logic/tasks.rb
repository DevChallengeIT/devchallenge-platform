# frozen_string_literal: true

module Tasks
  extend self

  delegate :can_user_do_task?,    to: UserTaskPolicy
  delegate :total_assessment_for, to: AssessmentCalculator
end
