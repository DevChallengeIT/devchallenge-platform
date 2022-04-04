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
    expect(page).to have_content "Full name can't be blank"

    expect(page).to have_current_path '/'
    expect(page).to have_link user.full_name

    # Empty current_password
    fill_in 'Full Name', with: 'New User Name'
    fill_in 'Current Password', with: ''
    click_button 'Update'
    expect(page).to have_content "Current password can't be blank"

    expect(page).to have_current_path '/'
    expect(page).to have_link user.full_name
  end

  it 'success' do
    login_as(user)

    visit '/profile'

    fill_in 'Full Name', with: 'New User Name'
    fill_in 'Current Password', with: 'password'
    click_button 'Update'

    expect(page).to have_current_path '/'
    expect(page).to have_link 'New User Name'
  end
end
