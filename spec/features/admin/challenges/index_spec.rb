# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Challenges/Index' do
  it 'failure without session' do
    visit '/admin/challenges'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/challenges'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    challenge = create(:challenge)

    assume_logged_in(admin: true)
    visit '/admin/challenges'

    within "#challenge-#{challenge.id}" do
      expect(page).to have_link challenge.title, href: "/admin/challenges/#{challenge.slug}/edit"
      expect(page).to have_content challenge.status
      expect(page).to have_content challenge.registration_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content challenge.start_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content challenge.finish_at.strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end

  it 'handles pagination' do
    create(:challenge)
    create(:challenge)

    assume_logged_in(admin: true)
    visit '/admin/challenges?per_page=1'

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/challenges?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/challenges?per_page=1&page=2']", text: 'Next'
    end
  end

  it 'handles user time_zone' do
    challenge = create(:challenge)
    user = create(:user, :admin, time_zone: 'Kyiv')

    assume_logged_in(user)
    visit '/admin/challenges'

    within "#challenge-#{challenge.id}" do
      expect(page).to have_link challenge.title, href: "/admin/challenges/#{challenge.slug}/edit"
      expect(page).to have_content challenge.status
      expect(page).to have_content challenge
        .registration_at
        .in_time_zone(user.time_zone)
        .strftime(UI::TimestampComponent::TIME_FORMAT)

      expect(page).to have_content challenge
        .start_at
        .in_time_zone(user.time_zone)
        .strftime(UI::TimestampComponent::TIME_FORMAT)

      expect(page).to have_content challenge
        .finish_at
        .in_time_zone(user.time_zone)
        .strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end

  it 'can search' do
    challenge_a = create(:challenge, title: 'Yellow')
    challenge_b = create(:challenge, title: 'Blue')

    assume_logged_in(admin: true)
    visit '/admin/challenges?search=ell'

    expect(page).to have_content challenge_a.title
    expect(page).not_to have_content challenge_b.title
  end
end
