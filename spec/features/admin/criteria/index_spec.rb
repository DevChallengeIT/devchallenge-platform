# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Criteria/Index' do
  let!(:task) { create(:task) }
  let!(:criterium1) { create(:task_criterium, task:) }
  let!(:criterium2) { create(:task_criterium, task:) }
  let!(:challenge) { task.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"

    within "#criterium-#{criterium1.id}" do
      expect(page).to have_link(
        criterium1.title,
        href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/#{criterium1.id}/edit"
      )
      expect(page).to have_content criterium1.title
      expect(page).to have_content criterium1.max_value
    end
  end

  it 'handles pagination' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria?per_page=1"

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css(
        "a[href='/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria?per_page=1&page=2']",
        text: '2'
      )
      expect(page).to have_css(
        "a[href='/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria?per_page=1&page=2']",
        text: 'Next'
      )
    end

    expect(page).to have_css "#criterium-#{criterium1.id}"
    expect(page).not_to have_css "#criterium-#{criterium2.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path(
        "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria?per_page=1&page=2"
      )
    end

    expect(page).to have_css "#criterium-#{criterium2.id}"
    expect(page).not_to have_css "#criterium-#{criterium1.id}"
  end
end
