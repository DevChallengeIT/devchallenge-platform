# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::UserTaskPolicy do
  subject(:policy) { Competition.can_user_do_task?(user:, task:) }

  let(:user)           { member.user }
  let(:member)         { create(:member) }
  let(:task)           { create(:task, challenge: member.challenge, min_assessment: 27, dependent_task:) }
  let(:dependent_task) { create(:task) }

  context 'when a task is not started' do
    before do
      allow(Competition::TasksAssessmentCalculator).to receive(:total_assessment_for).with(participant: member, task: dependent_task).and_return(28)
    end

    it 'returns true' do
      travel_to Time.parse('2022-04-30 10:00:00').utc do
        expect(policy).to be true
      end
    end
  end

  context 'when a task is started but with missing dependent task' do
    let(:dependent_task) { nil }

    it { expect(policy).to be true }
  end

  context 'when a dependent task assessed enough' do
    before do
      allow(Competition::TasksAssessmentCalculator).to receive(:total_assessment_for).with(participant: member, task: dependent_task).and_return(28)
    end

    it { expect(policy).to be true }
  end

  context 'when assessment is equal to min assessment' do
    before do
      allow(Competition::TasksAssessmentCalculator).to receive(:total_assessment_for).with(participant: member, task: dependent_task).and_return(27)
    end

    it { expect(policy).to be true }
  end

  context 'when a dependent task not assessed enough' do
    before do
      allow(Competition::TasksAssessmentCalculator).to receive(:total_assessment_for).with(participant: member, task: dependent_task).and_return(26)
    end

    it { expect(policy).to be_falsey }
  end
end
