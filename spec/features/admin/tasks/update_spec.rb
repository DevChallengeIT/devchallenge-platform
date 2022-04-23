# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Tasks/Update' do
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

  it 'failure with empty title' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    fill_in 'Title', with: ''
    click_button 'Update'
    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}"
    expect(page).not_to have_content 'Task was successfully updated'
  end

  it 'failure with invalid timestamps' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    fill_in 'Start at',        with: '2022-04-06 15:33:14'
    fill_in 'Submit at',       with: '2022-04-06 15:33:13'
    fill_in 'Result at',       with: '2022-04-06 15:33:12'
    click_button 'Update'

    within '#start_at-errors' do
      expect(page).to have_content 'must be less than 2022-04-06 15:33:12 UTC'
    end

    within '#submit_at-errors' do
      expect(page).to have_content 'must be greater than 2022-04-06 15:33:14 UTC'
    end

    within '#result_at-errors' do
      expect(page).to have_content 'must be greater than 2022-04-06 15:33:13 UTC'
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}"
    expect(page).not_to have_content 'Task was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

    fill_in 'Title',                with: 'OK task'
    fill_in 'Slug',                 with: 'ok-task'
    # fill_in 'Description',          with: 'Lorem description' # TODO: Fix trix
    fill_in 'Start at',             with: '2022-05-01 10:00:00'
    fill_in 'Submit at',            with: '2022-05-10 09:00:00'
    fill_in 'Result at',            with: '2022-05-15 18:00:00'

    click_button 'Update'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks"
    expect(page).to have_content 'Task was successfully updated'

    within "#task-#{task.id}" do
      expect(page).to have_content 'OK task'
      expect(page).to have_content Time.zone.parse('2022-05-01 10:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content Time.zone.parse('2022-05-10 09:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content Time.zone.parse('2022-05-15 18:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content task.challenge.title
    end
  end
end
