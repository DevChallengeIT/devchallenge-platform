# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Vendors/Index' do
  it 'failure without session' do
    visit '/admin/vendors'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/vendors'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  context 'when logged in as admin' do
    let!(:vendor) { create(:vendor) }

    before do
      assume_logged_in(admin: true)
    end

    it 'success' do
      visit '/admin/vendors'

      within "#vendor-#{vendor.id}" do
        expect(page).to have_link vendor.name, href: "/admin/vendors/#{vendor.id}/edit"
        expect(page).to have_content vendor.name
      end
    end
  end

  context 'with pagination' do
    it 'handles pagination' do
      create(:vendor)
      create(:vendor)

      assume_logged_in(admin: true)
      visit '/admin/vendors?per_page=1'

      within '.pagination' do
        expect(page).to have_css "span[class='page active']", text: '1'
        expect(page).to have_css "a[href='/admin/vendors?per_page=1&page=2']", text: '2'
        expect(page).to have_css "a[href='/admin/vendors?per_page=1&page=2']", text: 'Next'
      end
    end
  end
end
