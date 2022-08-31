# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::JudgeService do
  describe 'auto_assign_judge' do
    let(:task_submission) { create(:task_submission) }

    context 'when no judges' do
      it 'skips judge assigment' do
        Competition.auto_assign_judge(task_submission:)
        expect(task_submission.reload.judge_id).to eq nil
      end
    end

    context 'when have one judge' do
      let!(:judge) { create(:member, :judge, challenge: task_submission.task.challenge) }

      it 'skips judge assigment' do
        Competition.auto_assign_judge(task_submission:)
        expect(task_submission.reload.judge_id).to eq judge.id
      end
    end

    context 'when have multiple one judge' do
      let(:challenge) { create(:challenge) }
      let(:task) { create(:task, challenge:) }

      let!(:judge_a) { create(:member, :judge, challenge:) }
      let!(:judge_b) { create(:member, :judge, challenge:) }

      let(:task_submission_a) { create(:task_submission, task:) }
      let(:task_submission_b) { create(:task_submission, task:) }
      let(:task_submission_c) { create(:task_submission, task:) }
      let(:task_submission_d) { create(:task_submission, task:) }
      let(:task_submission_e) { create(:task_submission, task:) }

      it 'assign next judge as round-robin' do
        Competition.auto_assign_judge(task_submission: task_submission_a)
        expect(task_submission_a.reload.judge_id).to eq judge_a.id

        Competition.auto_assign_judge(task_submission: task_submission_b.reload)
        expect(task_submission_b.reload.judge_id).to eq judge_b.id

        Competition.auto_assign_judge(task_submission: task_submission_c.reload)
        expect(task_submission_c.reload.judge_id).to eq judge_a.id

        Competition.auto_assign_judge(task_submission: task_submission_d.reload)
        expect(task_submission_d.reload.judge_id).to eq judge_b.id

        Competition.auto_assign_judge(task_submission: task_submission_e.reload)
        expect(task_submission_e.reload.judge_id).to eq judge_a.id
      end
    end
  end
end
