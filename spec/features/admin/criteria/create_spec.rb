# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Criteria/Create' do
  let!(:task) { create(:task) }
  let!(:challenge) { task.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/new"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/new"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/new"

    fill_in 'Max value', with: '0'
    click_button 'Create'

    within '#max_value-errors' do
      expect(page).to have_content 'must be greater than 0'
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"
    expect(page).not_to have_content 'Criterion was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/new"

    fill_in 'Title', with: 'new criterion'
    fill_in 'Max value', with: 10
    click_button 'Create'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"
    expect(page).to have_content 'Criterion was successfully created'
  end
end
