# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log In' do
  let(:user) { create(:user) }

  it 'failure' do
    login_as(user)

    visit '/profile'

    # Empty name
    fill_in 'Full Name', with: ''
    fill_in 'Current Password', with: 'password'
    click_button 'Update'
    within '#full_name-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path '/'
    expect(page).to have_link user.full_name

    # Empty current_password
    fill_in 'Full Name', with: 'New User Name'
    fill_in 'Phone', with: '123456789'
    fill_in 'Password', with: 'NewPassword'
    fill_in 'Confirm password', with: 'NewPassword'
    fill_in 'Current Password', with: ''
    click_button 'Update'
    within '#current_password-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path '/'
    expect(page).to have_link user.full_name
  end

  it 'success' do
    login_as(user)

    visit '/profile'

    fill_in 'Full Name', with: 'New User Name'
    fill_in 'Phone', with: '123456789'
    select '(GMT+02:00) Kyiv', from: 'Time Zone'
    fill_in 'Current Password', with: 'password'
    click_button 'Update'

    expect(page).to have_current_path '/'
    expect(page).to have_link 'New User Name'
    expect(user.reload).to have_attributes(
      full_name:    'New User Name',
      time_zone:    'Kyiv',
      phone_number: '123456789'
    )
  end
end
