# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Assessments/Create' do
  let!(:task) { create(:task) }
  let!(:task_criterium_a) { create(:task_criterium, task:) }
  let!(:task_criterium_b) { create(:task_criterium, task:) }
  let!(:judge) { create(:member, :judge, challenge: task.challenge) }
  let!(:submission) do
    create(
      :task_submission,
      member: build(:member, challenge: task.challenge),
      notes:  'this is my submission',
      task:
    )
  end

  context "with judge's session" do
    before { assume_logged_in(judge.user) }

    it 'creates assessments' do
      visit "submissions/#{submission.id}/assessments/new"

      # save_and_open_page
      fill_in "assesment[#{task_criterium_a.id}][value]", with: 10
      fill_in "assesment[#{task_criterium_a.id}][comment]", with: 'Awesome job!'

      fill_in "assesment[#{task_criterium_b.id}][value]", with: 8
      fill_in "assesment[#{task_criterium_b.id}][comment]", with: 'Also ok'

      click_button 'Create'

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Task Assessment was successfully created'
      expect(page).not_to have_content 'Pending'

      expect(task.task_assessments.count).to eq 2
      expect(task.task_assessments).to match_array(
        [
          have_attributes(
            value:              10,
            comment:            'Awesome job!',
            judge_id:           judge.id,
            task_criterium_id:  task_criterium_a.id,
            task_submission_id: submission.id
          ),
          have_attributes(
            value:              8,
            comment:            'Also ok',
            judge_id:           judge.id,
            task_criterium_id:  task_criterium_b.id,
            task_submission_id: submission.id
          )
        ]
      )
    end
  end

  context "with not judge's session" do
    it 'does not show task submissions if there is not session' do
      visit "submissions/#{submission.id}/assessments/new"

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it "redirects to root in case of regular admin's session" do
      assume_logged_in(admin: true)

      visit "submissions/#{submission.id}/assessments/new"

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Access denied'
    end
  end

  it "redirects to root in case of participant's session" do
    assume_logged_in(submission.member.user)

    visit "submissions/#{submission.id}/assessments/new"

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Access denied'
  end
end
