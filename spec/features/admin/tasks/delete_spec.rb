# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Tasks/Delete' do
  let!(:task) { create(:task) }
  let!(:challenge) { task.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure because task has dependent task' do
    create(:task, dependent_task: task)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    click_button 'Remove'
    expect(page).to have_content 'Task can not be removed as it has dependent tasks or submissions'
    expect(page).to have_current_path("/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit")
    expect(task.reload).to be_present
  end

  it 'failure because task has submission' do
    create(:task_submission, task:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    click_button 'Remove'
    expect(page).to have_content 'Task can not be removed as it has dependent tasks or submissions'
    expect(page).to have_current_path("/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit")
    expect(task.reload).to be_present
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    click_button 'Remove'
    expect(page).to have_content 'Task was successfully removed'
    expect(page).to have_current_path("/admin/challenges/#{challenge.slug}/tasks")
    expect { task.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
