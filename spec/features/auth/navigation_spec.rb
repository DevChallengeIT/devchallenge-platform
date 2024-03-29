# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation' do
  let(:user) { create(:user) }

  context 'without session' do
    it 'has navigation links' do
      visit root_path

      within '#main-nav' do
        click_link 'Log In'
        expect(page).to have_current_path '/login'

        # TODO: Why it does not handle within scope?
        # click_link 'Register'
        # expect(page).to have_current_path '/register'

        expect(page).not_to have_link user.full_name
        expect(page).not_to have_link 'Admin'
      end
    end
  end

  context 'with session' do
    it 'has navigation links' do
      assume_logged_in(user)
      visit root_path

      within '#main-nav' do
        click_link current_user.full_name
        expect(page).to have_current_path '/profile'

        click_link 'Log Out'
        expect(page).to have_current_path '/'

        expect(page).not_to have_link current_user.full_name
        expect(page).not_to have_link 'Admin'
      end
    end
  end

  context 'with admin session' do
    it 'has navigation links' do
      assume_logged_in(admin: true)
      visit root_path

      within '#main-nav' do
        click_link current_user.full_name
        expect(page).to have_current_path '/profile'

        click_link 'Admin'
        expect(page).to have_current_path '/admin'

        click_link 'Challenges'
        expect(page).to have_current_path '/admin/challenges'

        click_link 'Taxonomies'
        expect(page).to have_current_path '/admin/taxonomies'

        click_link 'Judges'
        expect(page).to have_current_path '/admin/judges'
      end

      within '#main-nav' do
        click_link 'Log Out'
        expect(page).to have_current_path '/'
      end

      within '#main-nav' do
        expect(page).not_to have_link current_user.full_name
      end
    end
  end
end
