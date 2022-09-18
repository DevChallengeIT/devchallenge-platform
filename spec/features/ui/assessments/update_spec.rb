# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Assessments/Update' do
  let!(:task) { create(:task) }
  let!(:task_criterium) { create(:task_criterium, task:) }
  let!(:judge) { create(:member, :judge, challenge: task.challenge) }
  let!(:submission) do
    create(
      :task_submission,
      member: build(:member, challenge: task.challenge),
      notes:  'this is my submission',
      task:
    )
  end
  let!(:assessment) do
    create(
      :task_assessment,
      task_criterium:,
      task_submission: submission,
      judge:,
      value:           10,
      comment:         'nice job!!!'
    )
  end

  context "with judge's session" do
    before { assume_logged_in(judge.user) }

    it 'updates assessment' do
      visit "submissions/#{submission.id}/assessments/edit"

      expect(page).to have_field("assesment[#{task_criterium.id}][value]", with: assessment.value)
      expect(page).to have_field("assesment[#{task_criterium.id}][comment]", with: assessment.comment)

      expect(submission.task_assessments.count).to eq(1)

      fill_in "assesment[#{task_criterium.id}][value]", with: 5
      fill_in "assesment[#{task_criterium.id}][comment]", with: 'not so nice :('

      click_button 'Update'
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Task Assessment was successfully updated'

      expect(task.task_assessments).to match_array(
        [
          have_attributes(
            value:              5,
            comment:            'not so nice :(',
            judge_id:           judge.id,
            task_criterium_id:  task_criterium.id,
            task_submission_id: submission.id
          )
        ]
      )
    end
  end

  context "with not judge's session" do
    it 'does not show task submissions if there is not session' do
      visit "submissions/#{submission.id}/assessments/edit"

      expect(page).not_to have_button 'Update'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it "redirects to root in case of regular admin's session" do
      assume_logged_in(admin: true)
      visit "submissions/#{submission.id}/assessments/edit"

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Access denied'
    end

    it "redirects to root in case of participant's session" do
      assume_logged_in(submission.member.user)
      visit "submissions/#{submission.id}/assessments/edit"

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Access denied'
    end
  end
end
