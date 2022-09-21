# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::TasksAssessmentCalculator do
  subject(:result) { described_class.total_assessment_for(participant:, task:) }

  let(:participant) { create(:member, challenge:) }
  let(:challenge) { create(:challenge) }
  let(:task) { create(:task, challenge:) }

  let(:value_a1) { rand(0..10) }
  let(:value_a2) { rand(0..10) }
  let(:value_b1) { rand(0..10) }
  let(:value_b2) { rand(0..10) }

  before do
    judge_a = create(:member, :judge, challenge:)
    judge_b = create(:member, :judge, challenge:)
    task_criterium_a = create(:task_criterium, task:)
    task_criterium_b = create(:task_criterium, task:)
    task_submission = create(:task_submission, member: participant, task:)
    create(:task_assessment, task_submission:, judge: judge_a, task_criterium: task_criterium_a, value: value_a1)
    create(:task_assessment, task_submission:, judge: judge_a, task_criterium: task_criterium_b, value: value_a2)
    create(:task_assessment, task_submission:, judge: judge_b, task_criterium: task_criterium_a, value: value_b1)
    create(:task_assessment, task_submission:, judge: judge_b, task_criterium: task_criterium_b, value: value_b2)

    # Other member
    other_member = create(:member, challenge:)
    other_task_submission = create(:task_submission, member: other_member, task:)
    create(:task_assessment, task_submission: other_task_submission, judge: judge_a, task_criterium: task_criterium_a, value: value_a1)
    create(:task_assessment, task_submission: other_task_submission, judge: judge_a, task_criterium: task_criterium_b, value: value_a2)
    create(:task_assessment, task_submission: other_task_submission, judge: judge_b, task_criterium: task_criterium_a, value: value_b1)
    create(:task_assessment, task_submission: other_task_submission, judge: judge_b, task_criterium: task_criterium_b, value: value_b2)
  end

  it 'returns a sum of all assessments for a participant submission' do
    expect(result).to eql((value_a1 + value_a2 + value_b1 + value_b2) / 2)
  end
end
