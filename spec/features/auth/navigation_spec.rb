# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation' do
  let(:user) { create(:user) }

  context 'without session' do
    it 'has navigation links' do
      visit root_path

      within '#main-nav' do
        click_link 'Home'
        expect(page).to have_current_path '/'

        click_link 'Log In'
        expect(page).to have_current_path '/login'

        click_link 'Register'
        expect(page).to have_current_path '/register'

        expect(page).not_to have_link user.full_name
      end
    end
  end

  context 'with session' do
    it 'has navigation links' do
      login_as(user)
      visit root_path

      within '#main-nav' do
        click_link 'Home'
        expect(page).to have_current_path '/'

        click_link user.full_name
        expect(page).to have_current_path '/profile'

        click_link 'Log Out'
        expect(page).to have_current_path '/'

        expect(page).not_to have_link user.full_name
      end
    end
  end
end
