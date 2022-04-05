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
      expect(page).to have_content challenge.title
      expect(page).to have_content challenge.status
      expect(page).to have_content challenge.registration_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content challenge.start_at.strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content challenge.finish_at.strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end
end
