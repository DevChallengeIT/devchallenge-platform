# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::UserTaskPolicy do
  subject(:policy) { Competition.can_user_do_task?(user:, task:) }

  let(:user) { participant.user }
  let(:participant) { create(:member) }
  let(:task) { create(:task, challenge: participant.challenge, dependent_task:) }
  let(:dependent_task) {}

  context 'when a task is not started' do
    it 'returns falsey' do
      travel_to Time.parse('2022-04-30 10:00:00').utc do
        expect(policy).to be_falsey
      end
    end
  end

  context 'when a task is started but with missing dependent task' do
    it { expect(policy).to be true }
  end

  context 'when a dependent task assessed enough' do
    let(:dependent_task) do
      create(
        :task,
        challenge:        participant.challenge,
        task_submissions: create_list(
          :task_submission,
          1,
          task_assessments: create_list(:task_assessment, 3, value:),
          member:           participant
        ),
        min_assessment:   27
      )
    end
    let(:value) { 10 }

    it { expect(policy).to be true }

    context 'when assessment is equal to min assessment' do
      let(:value) { 9 }

      it { expect(policy).to be true }
    end

    context 'when a dependent task not assessed enough' do
      let(:value) { 8 }

      it { expect(policy).to be_falsey }
    end
  end
end
