# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskAssessment/Create' do
  let!(:task_submission) { create(:task_submission) }
  let!(:task) { task_submission.task }
  let!(:challenge) { task.challenge }
  let!(:task_criterium) { create(:task_criterium, task:) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/new?task_criterium_id=#{task_criterium.id}&task_submission_id=#{task_submission.id}" # rubocop:disable Layout/LineLength

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/new?task_criterium_id=#{task_criterium.id}&task_submission_id=#{task_submission.id}" # rubocop:disable Layout/LineLength

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/new?task_criterium_id=#{task_criterium.id}&task_submission_id=#{task_submission.id}" # rubocop:disable Layout/LineLength

    fill_in 'task_assessment_value', with: ''
    click_button 'Create Task assessment'

    within '#value-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path(
      "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments?task_criterium_id=#{task_criterium.id}&task_submission_id=#{task_submission.id}" # rubocop:disable Layout/LineLength
    )
    expect(page).not_to have_content 'Task Assessment was successfully created'
  end

  it 'success' do
    create(:task_criterium, task:)
    assume_logged_in(admin: true)
    create(:member, challenge:, user: current_user)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/assessments/new?task_criterium_id=#{task_criterium.id}&task_submission_id=#{task_submission.id}" # rubocop:disable Layout/LineLength

    fill_in 'task_assessment_value', with: '15'
    click_button 'Create Task assessment'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Task Assessment was successfully created'
  end
end
