# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Tasks/Show' do
  let!(:task) { create(:task) }

  context 'without session' do
    it 'can not access' do
      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path '/login'
      expect(page).to have_content 'You need to sign in or sign up'
    end
  end

  context 'with session' do
    it 'can not access without challenge membership' do
      assume_logged_in

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can access with challenge membership' do
      assume_logged_in
      create(:member, user: current_user, challenge: task.challenge)

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).not_to have_link 'Edit'
    end

    it 'can access as admin' do
      assume_logged_in(admin: true)

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_link 'Edit'
    end
  end
end
