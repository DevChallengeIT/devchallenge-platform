# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskSubmissions/Index' do
  let!(:task) { create(:task) }
  let!(:challenge) { task.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    task_submission = create(:task_submission, notes: 'first submission', task:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    within "#task_submission-#{task_submission.id}" do
      expect(page).to have_content task_submission.member.user.email
      expect(page).to have_content 'first submission'
    end
  end

  it 'handles pagination' do
    task_submission_a = create(:task_submission, task:)
    task_submission_b = create(:task_submission, task:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions?per_page=1"

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#task_submission-#{task_submission_a.id}"
    expect(page).not_to have_css "#task_submission-#{task_submission_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions?per_page=1&page=2"
    end

    expect(page).to have_css "#task_submission-#{task_submission_b.id}"
    expect(page).not_to have_css "#task_submission-#{task_submission_a.id}"
  end
end
