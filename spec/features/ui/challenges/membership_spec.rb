# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Challenges/Join' do
  let(:challenge) { create(:challenge) }

  context 'without session' do
    context 'when challenge is opened' do
      it 'do not renders join button' do
        visit "/challenges/#{challenge.slug}"

        expect(page).not_to have_button 'Join'
        expect(page).not_to have_button 'Leave'
        expect(page).to have_content 'Join Log In / Register'
      end
    end

    context 'when challenge is closed' do
      let(:challenge) { create(:challenge, :registration_closed) }

      it 'do not renders join button' do
        visit "/challenges/#{challenge.slug}"

        expect(page).not_to have_button 'Join'
        expect(page).not_to have_button 'Leave'
        expect(page).to have_content 'Registration is already closed'
      end
    end
  end

  context 'with session' do
    before { assume_logged_in }

    context 'when challenge registration is opened' do
      it 'can join the challenge if not yet joined' do
        visit "/challenges/#{challenge.slug}"

        click_button 'Accept & Join'
        expect(page).to have_current_path "/challenges/#{challenge.slug}"
        expect(page).to have_content 'challenge is accepted'
        expect(page).not_to have_button 'Join'
        expect(page).to have_button 'Leave'
      end

      it 'can leave the challenge if the user is already a member of the challenge' do
        create(:member, challenge:, user: current_user)

        visit "/challenges/#{challenge.slug}"

        click_button 'Leave'
        expect(page).to have_current_path "/challenges/#{challenge.slug}"
        expect(page).to have_content 'So pity that you leaving us...'
        expect(page).to have_button 'Join'
        expect(page).not_to have_button 'Leave'
      end
    end

    context 'when challenge is registration is not yet opened' do
      let(:challenge) { create(:challenge, :registration_not_opened) }

      it 'do not renders join button' do
        visit "/challenges/#{challenge.slug}"

        expect(page).not_to have_button 'Join'
        expect(page).not_to have_button 'Leave'
        expect(page).to have_content 'Registration is not yet open'
      end
    end

    context 'when challenge is registration is closed' do
      let(:challenge) { create(:challenge, :registration_closed) }

      it 'do not renders join button' do
        visit "/challenges/#{challenge.slug}"

        expect(page).not_to have_button 'Join'
        expect(page).not_to have_button 'Leave'
        expect(page).to have_content 'Registration is already closed'
      end
    end
  end
end
