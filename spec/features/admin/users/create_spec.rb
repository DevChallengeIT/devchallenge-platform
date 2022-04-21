# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Users/Create' do
  it 'failure without session' do
    visit '/admin/users/new'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/users/new'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit '/admin/users/new'

    fill_in 'user_full_name', with: ''
    click_button 'Create'

    within '#full_name-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path '/admin/users'
    expect(page).not_to have_content 'User was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit '/admin/users/new'

    fill_in 'Email', with: 'test@mail.com'
    fill_in 'Full name', with: 'Test User'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Create'
    expect(page).to have_current_path '/admin/users/test-user/edit'
    expect(page).to have_content 'User was successfully created'
  end
end
