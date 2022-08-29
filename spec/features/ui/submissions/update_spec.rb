# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Submissions/Update' do
  let!(:task) do
    create(:task,
           require_attachment: true,
           start_at:           1.minute.ago,
           submit_at:          1.minute.from_now,
           result_at:          2.minutes.from_now)
  end
  let!(:member) { create(:member, challenge: task.challenge) }
  let!(:user) { member.user }
  let!(:task_submission) do
    create(
      :task_submission,
      member:,
      task:,
      notes:  'professionally submitted task'
    )
  end

  context 'without session' do
    it 'does not render `Submit` button' do
      visit "/tasks/#{task.slug}"

      expect(page).not_to have_button 'Submit'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'with session' do
    before { assume_logged_in(user) }

    it 'updates the task submission' do
      visit "/tasks/#{task.slug}"

      expect(task.task_submissions.count).to eq(1)
      expect(task_submission.notes).to eq('professionally submitted task')

      fill_in 'Notes', with: 'updated task submission'

      click_button 'Update'

      expect(task.task_submissions.count).to eq(1)
      expect(task.task_submissions.first.zip_file.attachment.present?).to eq(false)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Submission was successfully updated'
      expect(page).not_to have_button 'Create Task submission'
      expect(page).not_to eq('professionally submitted task')
      expect(task_submission.reload.notes).to eq('updated task submission')
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Remove'
    end

    it 'updates the task submission file' do
      visit "/tasks/#{task.slug}"

      expect(task.task_submissions.count).to eq(1)
      expect(task_submission.notes).to eq('professionally submitted task')

      fill_in 'Notes', with: 'updated task submission'
      page.attach_file('Zip file', 'spec/support/assets/submission.zip')

      click_button 'Update'

      expect(task.task_submissions.count).to eq(1)
      expect(task.task_submissions.first.zip_file.attachment.present?).to eq(true)
      expect(page).to have_content 'Submission was successfully updated'
    end
  end
end
