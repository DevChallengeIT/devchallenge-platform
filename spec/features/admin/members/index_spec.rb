# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Members/Index' do
  let!(:challenge) { create(:challenge) }
  let!(:member1) { create(:member, challenge:) }
  let!(:member2) { create(:member, challenge:) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/members"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/members"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/members"

    within "#member-#{member1.id}" do
      expect(page).to have_link member1.user.email,
                                href: "/admin/challenges/#{challenge.slug}/members/#{member1.id}/edit"
      expect(page).to have_content member1.role
      expect(page).to have_content member1.created_at.strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end

  it 'handles pagination' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/members?per_page=1"

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/members?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/challenges/#{challenge.slug}/members?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#member-#{member1.id}"
    expect(page).not_to have_css "#member-#{member2.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/members?per_page=1&page=2"
    end

    expect(page).to have_css "#member-#{member2.id}"
    expect(page).not_to have_css "#member-#{member1.id}"
  end
end
