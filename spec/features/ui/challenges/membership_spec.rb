# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Challenges/Join' do
  let(:challenge) { create(:challenge) }

  context 'without session' do
    it 'do not renders join button' do
      visit "/challenges/#{challenge.slug}"

      expect(page).not_to have_button 'Join'
      expect(page).not_to have_button 'Leave'
      expect(page).to have_content 'Please register to join this challenge'
    end
  end

  context 'with session' do
    before { assume_logged_in }

    it 'can join the challenge if not yet joined' do
      visit "/challenges/#{challenge.slug}"

      click_button 'Join'
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_content 'Thanks! You joined the challenge'
      expect(page).not_to have_button 'Join'
      expect(page).to have_button 'Leave'
    end

    it 'can leave the challenge if not yet joined' do
      create(:member, challenge:, user: current_user)

      visit "/challenges/#{challenge.slug}"

      click_button 'Leave'
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_content 'So pity that you leaving us...'
      expect(page).to have_button 'Join'
      expect(page).not_to have_button 'Leave'
    end
  end
end
