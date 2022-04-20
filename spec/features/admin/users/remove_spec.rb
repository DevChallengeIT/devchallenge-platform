# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Users/Remove' do
  let!(:user) { create(:user) }

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/users/#{user.slug}/edit"

    click_button 'Remove'

    expect(page).to have_current_path '/admin/users'
    expect(page).to have_content 'User was successfully removed'
  end
end
