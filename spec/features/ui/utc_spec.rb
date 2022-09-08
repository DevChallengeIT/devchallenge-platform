# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/UTC' do
  it 'displays time_zone info if time_zone == UTC and current_user not updated profile' do
    assume_logged_in
    visit '/challenges'

    expect(page).to have_content 'Your current profile time zone is UTC'
  end

  it 'does not display time_zone info if time_zone != UTC' do
    user = create(:user, time_zone: 'EET')
    assume_logged_in(user)
    visit '/challenges'

    expect(page).not_to have_content 'Your current profile time zone is UTC'
  end
end
