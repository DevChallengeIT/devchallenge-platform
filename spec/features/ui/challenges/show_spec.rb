# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Challenges/Show' do
  context 'without session' do
    it 'can not access draft challenge' do
      challenge = create(:challenge, status: 'draft')

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'

      assume_logged_in(admin: true)
      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
    end

    it 'can not access moderation challenge' do
      challenge = create(:challenge, status: 'moderation')

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can not access canceled challenge' do
      challenge = create(:challenge, status: 'canceled')

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can access ready challenge' do
      challenge = create(:challenge, status: 'ready')

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).not_to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end
  end

  context 'with admin session' do
    before { assume_logged_in(admin: true) }

    it 'can access draft challenge' do
      challenge = create(:challenge, status: 'draft')

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end

    it 'can access moderation challenge' do
      challenge = create(:challenge, status: 'moderation')

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end

    it 'can access canceled challenge' do
      challenge = create(:challenge, status: 'canceled')

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end

    it 'can access read challenge' do
      challenge = create(:challenge, status: 'ready')

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end
  end
end
