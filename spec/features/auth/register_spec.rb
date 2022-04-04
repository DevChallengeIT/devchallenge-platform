# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log In' do
  it 'failure' do
    visit '/register'

    # Empty form
    fill_in 'Full Name',        with: ''
    fill_in 'Email',            with: ''
    fill_in 'Password',         with: ''
    fill_in 'Confirm password', with: ''
    click_button 'Register'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
    expect(page).not_to have_link 'Log Out'

    # Existing user
    user = create(:user)

    fill_in 'Full Name',        with: user.full_name
    fill_in 'Email',            with: user.email
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'password'
    click_button 'Register'
    expect(page).to have_content 'Email has already been taken'
    expect(page).not_to have_link 'Log Out'

    # Password conformation didn't match
    fill_in 'Full Name',        with: 'New User'
    fill_in 'Email',            with: 'new-user@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'ooops'
    click_button 'Register'
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(page).not_to have_link 'Log Out'
  end

  it 'success' do
    visit '/register'

    fill_in 'Full Name',        with: 'New User'
    fill_in 'Email',            with: 'new-user@example.com'
    fill_in 'Password',         with: 'password'
    fill_in 'Confirm password', with: 'password'
    click_button 'Register'

    expect(page).to have_current_path '/'
    expect(page).to have_link 'Log Out'
  end
end
