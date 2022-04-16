# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Judges/Index' do
  it 'failure without session' do
    visit '/admin/judges'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/judges'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    judge = create(:member, :judge)

    assume_logged_in(admin: true)
    visit '/admin/judges'

    within "#judge-#{judge.id}" do
      expect(page).to have_content judge.user.email
      expect(page).to have_content judge.challenge.title
    end
  end

  it 'handles pagination' do
    judge_a = create(:member, :judge)
    judge_b = create(:member, :judge)

    assume_logged_in(admin: true)
    visit '/admin/judges?per_page=1'

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/judges?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/judges?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#judge-#{judge_a.id}"
    expect(page).not_to have_css "#judge-#{judge_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path '/admin/judges?per_page=1&page=2'
    end

    expect(page).to have_css "#judge-#{judge_b.id}"
    expect(page).not_to have_css "#judge-#{judge_a.id}"
  end
end
