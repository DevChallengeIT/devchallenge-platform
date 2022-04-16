# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Judges/Create' do
  it 'failure without session' do
    visit '/admin/judges/new'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/judges/new'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)

    member = create(:member, :judge)
    user = member.user
    challenge = member.challenge

    visit '/admin/judges/new'

    select user.email, from: 'judge_user_id'
    select challenge.title, from: 'judge_challenge_id'
    click_button 'Create'

    within '#user-errors' do
      expect(page).to have_content 'User with such email is already a judge in the selected challenge'
    end

    expect(page).to have_current_path '/admin/judges'
    expect(page).not_to have_content 'Judge was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)

    user = create(:user)
    challenge = create(:challenge)

    visit '/admin/judges/new'

    select user.email, from: 'judge_user_id'
    select challenge.title, from: 'judge_challenge_id'
    click_button 'Create'

    expect(page).to have_current_path '/admin/judges'
    expect(page).to have_content 'Judge was successfully created'
  end
end
