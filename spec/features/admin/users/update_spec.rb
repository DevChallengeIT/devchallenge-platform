# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Users/Update' do
  let!(:user) { create(:user) }

  it 'failure without session' do
    visit "/admin/users/#{user.slug}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/users/#{user.slug}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with empty email' do
    assume_logged_in(admin: true)
    visit "/admin/users/#{user.slug}/edit"

    fill_in 'Email', with: ''
    click_button 'Update'
    within '#email-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/users/#{user.slug}"
    expect(page).not_to have_content 'User was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/users/#{user.slug}/edit"

    fill_in 'Email',                with: 'test1@mail.com'
    fill_in 'Slug',                 with: 'test-user1'
    fill_in 'Full name',            with: 'Test User'
    select 'Hawaii',                from: 'Time zone'

    click_button 'Update'

    expect(page).to have_current_path '/admin/users'
    expect(page).to have_content 'User was successfully updated'

    within "#user-#{user.id}" do
      expect(page).to have_content 'test1@mail.com'
      expect(page).to have_content 'Hawaii'
      expect(page).to have_content 'test-user1'
      expect(page).to have_content 'Test User'
    end
  end
end
