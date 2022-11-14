# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Vendors/Update' do
  let!(:vendor) { create(:vendor) }

  it 'failure without session' do
    visit "/admin/vendors/#{vendor.id}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/vendors/#{vendor.id}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/vendors/#{vendor.id}/edit"

    fill_in 'Name', with: 'Vendor-2'
    click_button 'Update'

    expect(page).to have_current_path '/admin/vendors'
    expect(page).to have_content 'Vendor was successfully updated'

    within "#vendor-#{vendor.id}" do
      expect(page).to have_content 'Vendor-2'
    end
  end
end
