# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskAssessment/Remove' do
  let!(:task_assessment) { create(:task_assessment, comment: 'That is so amaizing job!!!') }
  let!(:task_submission) { task_assessment.task_submission }
  let!(:task) { task_assessment.task_submission.task }
  let!(:challenge) { task.challenge }

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    expect(page).to have_content "#{task_submission.member.user.full_name} (#{task_submission.member.user.email})"

    within "#task_submission-#{task_submission.id}" do
      click_button 'Remove'
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Submission was successfully removed'
    expect(page).not_to have_content "#{task_submission.member.user.full_name} (#{task_submission.member.user.email})"
  end
end
