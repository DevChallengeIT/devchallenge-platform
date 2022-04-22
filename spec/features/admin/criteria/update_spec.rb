# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Criteria/Update' do
  let(:criterium) { create(:task_criterium) }
  let!(:task) { criterium.task }

  it 'failure without session' do
    visit "/admin/tasks/#{task.slug}/criteria/#{criterium.id}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/tasks/#{task.slug}/criteria/#{criterium.id}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with zero max_value' do
    assume_logged_in(admin: true)
    visit "/admin/tasks/#{task.slug}/criteria/#{criterium.id}/edit"

    fill_in 'Max value', with: '0'
    click_button 'Update'
    within '#max_value-errors' do
      expect(page).to have_content 'must be greater than 0'
    end

    expect(page).to have_current_path "/admin/tasks/#{task.slug}/criteria/#{criterium.id}"
    expect(page).not_to have_content 'Criterion was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/tasks/#{task.slug}/criteria/#{criterium.id}/edit"

    fill_in 'Title', with: 'new criterion'
    fill_in 'Max value', with: 10

    click_button 'Update'

    expect(page).to have_current_path "/admin/tasks/#{task.slug}/criteria"
    expect(page).to have_content 'Criterion was successfully updated'

    within "#criterium-#{criterium.id}" do
      expect(page).to have_link criterium.reload.title, href: "/admin/tasks/#{task.slug}/criteria/#{criterium.id}/edit"
      expect(page).to have_content criterium.max_value
    end
  end
end
