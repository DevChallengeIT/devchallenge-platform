# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Members/Update' do
  let(:member) { create(:member) }
  let!(:challenge) { member.challenge }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"

    select 'judge', from: 'Role'

    click_button 'Update'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/members"
    expect(page).to have_content 'Member was successfully updated'

    within "#member-#{member.id}" do
      expect(page).to have_link member.user.email, href: "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"
      expect(page).to have_content 'judge'
      expect(page).to have_content member.created_at.strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end
end
