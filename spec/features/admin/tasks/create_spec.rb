# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Tasks/Create' do
  let!(:challenge) { create(:challenge) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/new"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/new"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/new"

    fill_in 'Title', with: ''
    click_button 'Create'

    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks"
    expect(page).not_to have_content 'Task was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)

    challenge = create(:challenge)

    visit "/admin/challenges/#{challenge.slug}/tasks/new"

    fill_in 'Title', with: 'new task'
    select challenge.title, from: 'task_challenge_id'
    click_button 'Create'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/new-task/edit"
    expect(page).to have_content 'Task was successfully created'
  end
end
