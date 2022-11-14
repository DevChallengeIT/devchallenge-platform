# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Vendors/Create' do
  it 'failure without session' do
    visit '/admin/vendors/new'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/vendors/new'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit '/admin/vendors/new'

    fill_in 'vendor_name', with: ''
    click_button 'Create'

    within '#name-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path '/admin/vendors'
    expect(page).not_to have_content 'User was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit '/admin/vendors/new'

    fill_in 'Name', with: 'Vendor-1'
    click_button 'Create'
    expect(page).to have_content 'Vendor was successfully created'
  end
end
