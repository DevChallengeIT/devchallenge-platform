# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Tasks/Index' do
  let!(:challenge) { create(:challenge) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    task = create(:task, challenge:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks"

    within "#task-#{task.id}" do
      expect(page).to have_link task.title, href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"
      expect(page).to have_content task.start_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content task.submit_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content task.result_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content task.challenge.title
    end
  end

  it 'handles pagination' do
    task_a = create(:task, challenge:)
    task_b = create(:task, challenge:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks?per_page=1"

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/tasks?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/tasks?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#task-#{task_a.id}"
    expect(page).not_to have_css "#task-#{task_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks?per_page=1&page=2"
    end

    expect(page).to have_css "#task-#{task_b.id}"
    expect(page).not_to have_css "#task-#{task_a.id}"
  end

  it 'handles user time_zone' do
    task = create(:task, start_at: '2022-05-01 10:00:00', challenge:)
    user = create(:user, :admin, time_zone: 'Kyiv')

    assume_logged_in(user)
    visit "/admin/challenges/#{challenge.slug}/tasks"

    within "#task-#{task.id}" do
      expect(page).to have_link task.title, href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/edit"

      expect(page).to have_content task
        .start_at
        .in_time_zone(user.time_zone)
        .strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end
end
