# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::UserTaskPolicy do
  subject(:policy) { Tasks.can_user_do_task?(user:, task:) }

  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe '.can_user_do_task?' do
    context 'when user is an admin' do
      let(:user) { create(:user, :admin) }

      it { expect(policy).to be true }
    end

    context 'when a user is a judge' do
      let(:user) { judge.user }
      let(:task) { create(:task, challenge: judge.challenge) }
      let(:judge) { create(:member, :judge) }

      it { expect(policy).to be true }
    end

    context 'when a participant' do
      let(:user) { participant.user }
      let(:participant) { create(:member) }
      let(:task) { create(:task, challenge: participant.challenge, dependent_task:) }
      let(:dependent_task) {}

      context 'when task is not started' do
        it 'returns falsey' do
          travel_to Time.parse('2022-04-30 10:00:00').utc do
            expect(policy).to be_falsey
          end
        end
      end

      context 'when task is already started' do
        context 'when the dependent task blank' do
          it { expect(policy).to be true }
        end

        context 'when the dependent task present and assessed enough' do
          let(:dependent_task) do
            create(:task,
                   challenge:        participant.challenge,
                   task_submissions:,
                   min_assessment:   27)
          end
          let(:task_submissions) do
            create_list(:task_submission, 1,
                        task_assessments:,
                        member:           participant)
          end
          let(:task_assessments) { create_list(:task_assessment, 3, value:) }
          let(:value) { 10 }

          it { expect(policy).to be true }

          context 'when assessment is equal to minimum assessment' do
            let(:value) { 9 }

            it { expect(policy).to be true }
          end

          context 'when the dependent task not assessed enough' do
            let(:value) { 8 }

            it { expect(policy).to be_falsey }
          end
        end
      end
    end

    context 'when just a random user, not participant' do
      it { expect(policy).to be_falsey }
    end
  end
end
