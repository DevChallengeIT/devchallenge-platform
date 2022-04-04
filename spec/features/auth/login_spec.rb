# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log In' do
  let(:user) { create(:user) }

  it 'failure' do
    visit root_path
    click_link 'Log In'

    expect(page).to have_current_path '/login'

    # Not existing user
    fill_in 'Email',    with: 'notexisting@user.test'
    fill_in 'Password', with: 'password'
    click_button 'Log In'

    expect(page).to have_current_path '/login'

    # Existing user, but invalid password
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: FFaker::Lorem.word
    click_button 'Log In'

    expect(page).to have_current_path '/login'
  end

  it 'success' do
    visit root_path
    click_link 'Log In'

    fill_in 'Email',    with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log In'

    expect(page).to have_current_path '/'
    expect(page).to have_link 'Log Out'
  end
end
