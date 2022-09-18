# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Assessments/Show' do
  let!(:task) { create(:task) }

  let!(:judge_a) { create(:member, :judge, challenge: task.challenge) }
  let!(:judge_b) { create(:member, :judge, challenge: task.challenge) }
  let!(:judge_c) { create(:member, :judge, challenge: task.challenge) }

  let(:member_a) { create(:member, challenge: task.challenge) }
  let(:member_b) { create(:member, challenge: task.challenge) }
  let(:member_c) { create(:member, challenge: task.challenge) }

  let!(:submission_a) do
    create(
      :task_submission,
      member: member_a,
      notes:  'submission_a',
      judge:  judge_a,
      task:
    )
  end

  let!(:submission_b) do
    create(
      :task_submission,
      member: member_b,
      notes:  'submission_b',
      judge:  judge_b,
      task:
    )
  end

  let!(:submission_c) do
    create(
      :task_submission,
      member: member_c,
      notes:  'submission_c',
      task:
    )
  end

  let(:criteria_a) { create(:task_criterium, task:) }
  let(:criteria_b) { create(:task_criterium, task:) }

  before do
    create(:task_assessment, task_submission: submission_a, task_criterium: criteria_a, judge: judge_a, value: 5)
    create(:task_assessment, task_submission: submission_a, task_criterium: criteria_b, judge: judge_a, value: 10)

    create(:task_assessment, task_submission: submission_b, task_criterium: criteria_a, judge: judge_b, value: 8)
    create(:task_assessment, task_submission: submission_b, task_criterium: criteria_b, judge: judge_b, value: 9)

    create(:task_assessment, task_submission: submission_c, task_criterium: criteria_a, judge: judge_a, value: 7)
    create(:task_assessment, task_submission: submission_c, task_criterium: criteria_b, judge: judge_a, value: 10)

    create(:task_assessment, task_submission: submission_c, task_criterium: criteria_a, judge: judge_b, value: 9)
    create(:task_assessment, task_submission: submission_c, task_criterium: criteria_b, judge: judge_b, value: 9)
  end

  context 'when judge a' do
    before { assume_logged_in(judge_a.user) }

    it 'displays only judges related submissions' do
      visit "/tasks/#{task.slug}"

      expect(page).to have_content 'Submissions'

      # Judge see his assigned submission
      within "#submission-#{submission_a.id}" do
        expect(page).to have_content 'submission_a'
        expect(page).to have_content '7.5'
        expect(page).to have_link 'Edit assessment', href: "/submissions/#{submission_a.id}/assessments/edit"
      end

      # Judge not see not his assigned submission
      expect(page).not_to have_content 'submission_b'

      # Judge see submission without assigned judge
      within "#submission-#{submission_c.id}" do
        expect(page).to have_content 'submission_c'
        expect(page).to have_content '8.5'
        expect(page).to have_link 'Edit assessment', href: "/submissions/#{submission_c.id}/assessments/edit"
      end
    end
  end

  context 'when judge b' do
    before { assume_logged_in(judge_b.user) }

    it 'displays only judges related submissions' do
      visit "/tasks/#{task.slug}"

      expect(page).to have_content 'Submissions'

      expect(page).not_to have_content 'submission_a'

      within "#submission-#{submission_b.id}" do
        expect(page).to have_content 'submission_b'
        expect(page).to have_content '8.5'
        expect(page).to have_link 'Edit assessment', href: "/submissions/#{submission_b.id}/assessments/edit"
      end

      within "#submission-#{submission_c.id}" do
        expect(page).to have_content 'submission_c'
        expect(page).to have_content '9'
        expect(page).to have_link 'Edit assessment', href: "/submissions/#{submission_c.id}/assessments/edit"
      end
    end
  end

  context 'when judge c' do
    before { assume_logged_in(judge_c.user) }

    it 'displays only judges related submissions' do
      visit "/tasks/#{task.slug}"

      expect(page).to have_content 'Submissions'

      expect(page).not_to have_content 'submission_a'
      expect(page).not_to have_content 'submission_b'

      within "#submission-#{submission_c.id}" do
        expect(page).to have_content 'submission_c'
        expect(page).to have_content 'Pending'
        expect(page).to have_link 'Add assessment', href: "/submissions/#{submission_c.id}/assessments/new"
      end
    end
  end
end
