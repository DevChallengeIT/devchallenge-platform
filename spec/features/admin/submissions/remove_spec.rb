# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskSubmissions/Remove' do
  it 'success' do
    task_submission = create(:task_submission)
    create(:task_assessment, task_submission:)
    task = task_submission.task
    challenge = task.challenge

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions/#{task_submission.id}/edit"

    click_button 'Remove'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Submission was successfully removed'
    expect(page).not_to have_content task_submission.member.user.email
  end
end
