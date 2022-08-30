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
    within '#top-controls' do
      click_button 'Update'
    end
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
    within '#top-controls' do
      click_button 'Update'
    end

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

    expect(page).to have_link 'View', href: "/tasks/#{task.slug}"
    expect(page).to have_link 'Submissions', href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_link 'Criteria', href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"

    fill_in 'Title',                with: 'OK task'
    fill_in 'Slug',                 with: 'ok-task'
    # fill_in 'Description',          with: 'Lorem description' # TODO: Fix trix
    fill_in 'Start at',             with: '2022-05-01 10:00:00'
    fill_in 'Submit at',            with: '2022-05-10 09:00:00'
    fill_in 'Result at',            with: '2022-05-15 18:00:00'
    fill_in 'Min assessment', with: '100'

    within '#top-controls' do
      click_button 'Update'
    end

    task.reload

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"
    expect(page).to have_content 'Task was successfully updated'
    expect(page).to have_content task.challenge.title

    expect(task.title).to eq 'OK task'
    expect(task.slug).to eq 'ok-task'
    expect(task.start_at).to eq '2022-05-01 10:00:00'
    expect(task.submit_at).to eq '2022-05-10 09:00:00'
    expect(task.result_at).to eq '2022-05-15 18:00:00'
    expect(task.min_assessment).to eq 100
  end
end
