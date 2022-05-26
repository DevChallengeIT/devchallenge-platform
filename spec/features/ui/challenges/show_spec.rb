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

    it 'displays tasks info' do
      challenge = create(:challenge, status: 'ready')
      task_a = create(:task, challenge:)
      task_b = create(:task, challenge:)

      visit "/challenges/#{challenge.slug}"
      expect(page).not_to have_link task_a.title, href: "/tasks/#{task_a.slug}"
      expect(page).not_to have_link task_b.title, href: "/tasks/#{task_b.slug}"
      expect(page).to have_content task_a.title
      expect(page).to have_content task_b.title
    end
  end

  context 'with regular user/member session' do
    before { assume_logged_in }

    it 'can not access draft challenge' do
      challenge = create(:challenge, status: 'draft')
      create(:member, user: current_user, challenge:)

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'

      assume_logged_in(admin: true)
      visit "/challenges/#{challenge.slug}"
      expect(page).to have_current_path "/challenges/#{challenge.slug}"
    end

    it 'can not access moderation challenge' do
      challenge = create(:challenge, status: 'moderation')
      create(:member, user: current_user, challenge:)

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can not access canceled challenge' do
      challenge = create(:challenge, status: 'canceled')
      create(:member, user: current_user, challenge:)

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can access ready challenge' do
      challenge = create(:challenge, status: 'ready')
      create(:member, user: current_user, challenge:)

      visit "/challenges/#{challenge.slug}"

      expect(page).to have_current_path "/challenges/#{challenge.slug}"
      expect(page).not_to have_link 'Edit', href: "/admin/challenges/#{challenge.slug}/edit"
    end

    it 'displays tasks links' do
      challenge = create(:challenge, status: 'ready')
      task_a = create(:task, challenge:)
      task_b = create(:task, challenge:)
      create(:member, user: current_user, challenge:)

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_link task_a.title, href: "/tasks/#{task_a.slug}"
      expect(page).to have_link task_b.title, href: "/tasks/#{task_b.slug}"
    end

    context 'without access to tasks, not a participant' do
      it 'displays tasks info' do
        challenge = create(:challenge, status: 'ready')
        task_a = create(:task, challenge:)
        task_b = create(:task, challenge:)
        current_member = challenge.members.find_by(user: current_user)
        expect(current_member).not_to be_present

        visit "/challenges/#{challenge.slug}"
        expect(page).not_to have_link task_a.title, href: "/tasks/#{task_a.slug}"
        expect(page).not_to have_link task_b.title, href: "/tasks/#{task_b.slug}"
        expect(page).to have_content task_a.title
        expect(page).to have_content task_b.title
      end
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

    it 'displays tasks links' do
      challenge = create(:challenge, status: 'ready')
      task_a = create(:task, challenge:)
      task_b = create(:task, challenge:)

      visit "/challenges/#{challenge.slug}"
      expect(page).to have_link task_a.title, href: "/tasks/#{task_a.slug}"
      expect(page).to have_link task_b.title, href: "/tasks/#{task_b.slug}"
    end
  end
end
