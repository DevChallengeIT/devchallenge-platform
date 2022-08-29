# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Submissions/Remove' do
  let!(:task) do
    create(:task,
           require_attachment: true,
           start_at:           1.minute.ago,
           submit_at:          1.minute.from_now,
           result_at:          2.minutes.from_now)
  end
  let!(:member) { create(:member, challenge: task.challenge) }
  let!(:user) { member.user }

  context 'without session' do
    it 'does not render `Update Task submission` button' do
      visit "/tasks/#{task.slug}"

      expect(page).not_to have_button 'Remove'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'with session' do
    before { assume_logged_in(user) }

    it 'removes the task submission' do
      create(:task_submission, member:, task:, notes: 'professionally submitted task')

      visit "/tasks/#{task.slug}"

      expect(task.task_submissions.count).to eq(1)

      click_button 'Remove'

      expect(task.task_submissions.count).to eq(0)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Submission was successfully removed'
      expect(page).to have_button 'Submit'
      expect(page).not_to have_button 'Remove'
    end
  end
end
