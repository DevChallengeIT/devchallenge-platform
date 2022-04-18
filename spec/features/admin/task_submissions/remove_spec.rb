# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskSubmissions/Remove' do
  it 'success' do
    task_submission = create(:task_submission)
    task = task_submission.task

    assume_logged_in(admin: true)
    visit "/admin/tasks/#{task.slug}/submissions"

    expect(page).to have_content task_submission.member.user.email

    within "#task_submission-#{task_submission.id}" do
      click_button 'Remove'
    end

    expect(page).to have_current_path "/admin/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Task Submission was successfully removed'
    expect(page).not_to have_content task_submission.member.user.email
  end
end
