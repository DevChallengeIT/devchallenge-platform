# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Submissions/Create' do
  let!(:task) { create(:task) }
  let!(:user) { create(:member, challenge: task.challenge).user }

  context 'without session' do
    it 'does not render `Create Task submission` button' do
      visit "/tasks/#{task.slug}"

      expect(page).not_to have_button 'Create Task submission'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'with session' do
    before { assume_logged_in(user) }

    it 'submits a task' do
      visit "/tasks/#{task.slug}"

      expect(task.task_submissions.count).to eq(0)

      fill_in 'Notes', with: 'professionally submitted task'

      click_button 'Create Task submission'

      expect(task.task_submissions.count).to eq(1)
      expect(task.task_submissions.first.zip_file.attachment.present?).to eq(false)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Submission was successfully created'
      expect(page).not_to have_button 'Create Task submission'
      expect(page).to have_button 'Update Task submission'
      expect(page).to have_button 'Remove'
    end

    it 'attaches a file a' do
      visit "/tasks/#{task.slug}"

      expect(task.task_submissions.count).to eq(0)

      fill_in 'Notes', with: 'professionally submitted task'
      page.attach_file('Zip file', 'spec/support/assets/submission.zip')

      click_button 'Create Task submission'

      expect(task.task_submissions.count).to eq(1)
      expect(task.task_submissions.first.zip_file.attachment.present?).to eq(true)
      expect(page).to have_content 'Submission was successfully created'
    end
  end
end
