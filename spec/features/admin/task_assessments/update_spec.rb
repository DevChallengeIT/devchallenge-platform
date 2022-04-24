# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskAssessment/Update' do
  let!(:task_assessment) { create(:task_assessment) }
  let!(:task) { task_assessment.task_submission.task }
  let!(:challenge) { task.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/#{task_assessment.id}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/#{task_assessment.id}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/#{task_assessment.id}/edit"

    fill_in 'task_assessment_value', with: ''
    click_button 'Update Task assessment'

    within '#value-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path(
      "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/#{task_assessment.id}"
    )
    expect(page).not_to have_content 'Task Assessment was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/#{task_assessment.id}/edit"

    fill_in 'task_assessment_value', with: '15'
    click_button 'Update Task assessment'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Task Assessment was successfully updated'
  end
end
