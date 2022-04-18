# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Members/Remove' do
  let(:member) { create(:member) }
  let!(:challenge) { member.challenge }

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"

    click_button 'Remove'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/members"
    expect(page).to have_content 'Member was successfully removed'
    expect(page).not_to have_link member.user.email,
                                  href: "/admin/challenges/#{challenge.slug}/members/#{member.id}/edit"
  end
end
