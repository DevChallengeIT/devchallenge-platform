# frozen_string_literal: true

module Competition
  extend self

  delegate :list_challenges,           to: ChallengesQuery
  delegate :list_taxonomies,           to: TaxonomiesQuery
  delegate :can_read?,                 to: ChallengePolicy
  delegate :can_join?,                 to: ChallengePolicy
  delegate :can_leave?,                to: ChallengePolicy
  delegate :registration_opened?,      to: ChallengePolicy
  delegate :registration_closed?,      to: ChallengePolicy
  delegate :registration_not_started?, to: ChallengePolicy
  delegate :can_user_do_task?,         to: UserTaskPolicy
  delegate :auto_assign_judge,         to: JudgeService
  delegate :task_results,              to: TaskResultsQuery
  delegate :task_sum_results,          to: TaskResultsQuery
  delegate :task_results_calculator,   to: TaskResultsCalculator
  delegate :create_assessments,        to: AssessmentService
  delegate :update_assessments,        to: AssessmentService
end
