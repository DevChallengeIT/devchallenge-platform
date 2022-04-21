# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Users/Index' do
  it 'failure without session' do
    visit '/admin/users'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/users'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    user = create(:user)

    assume_logged_in(admin: true)
    visit '/admin/users'

    within "#user-#{user.id}" do
      expect(page).to have_link user.email, href: "/admin/users/#{user.slug}/edit"
      expect(page).to have_content user.full_name
      expect(page).to have_content user.slug
      expect(page).to have_content user.time_zone
      expect(page).to have_content user.sign_in_count
    end
  end

  context 'with pagination' do
    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }

    it 'handles pagination' do
      assume_logged_in(admin: true)
      visit '/admin/users?per_page=1'

      within '.pagination' do
        expect(page).to have_css "span[class='page active']", text: '1'
        expect(page).to have_css "a[href='/admin/users?per_page=1&page=2']", text: '2'
        expect(page).to have_css "a[href='/admin/users?per_page=1&page=2']", text: 'Next'
      end

      expect(page).to have_css "#user-#{user_a.id}"
      expect(page).not_to have_css "#user-#{user_b.id}"

      within '.pagination' do
        click_link 'Next'
        expect(page).to have_current_path '/admin/users?per_page=1&page=2'
      end

      expect(page).to have_css "#user-#{user_b.id}"
      expect(page).not_to have_css "#user-#{user_a.id}"
    end
  end
end
