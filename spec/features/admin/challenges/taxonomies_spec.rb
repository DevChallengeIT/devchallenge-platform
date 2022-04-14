# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Challenges/Taxonomies' do
  it 'failure without session' do
    visit '/admin/challenges/taxonomies'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/challenges/taxonomies'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success open' do
    assume_logged_in(admin: true)
    visit '/admin/challenges'

    within '#challenges-nav' do
      click_link 'Taxonomies'
    end

    expect(page).to have_current_path '/admin/challenges/taxonomies'
  end

  it 'success management' do
    taxonomy = create(:taxonomy)

    assume_logged_in(admin: true)
    visit '/admin/challenges/taxonomies'

    within '#assigned-taxonomies' do
      expect(page).not_to have_content "- #{taxonomy.title}"
      expect(page).to have_content 'None'
    end

    within '#potential-taxonomies' do
      expect(page).to have_content "+ #{taxonomy.title}"
      expect(page).not_to have_content 'None'
    end

    # Assign taxonomy
    click_button taxonomy.title
    expect(page).to have_current_path '/admin/challenges/taxonomies'

    within '#assigned-taxonomies' do
      expect(page).to have_content "- #{taxonomy.title}"
      expect(page).not_to have_content 'None'
    end

    within '#potential-taxonomies' do
      expect(page).not_to have_content "+ #{taxonomy.title}"
      expect(page).to have_content 'None'
    end

    # Unassign taxonomy
    click_button taxonomy.title
    expect(page).to have_current_path '/admin/challenges/taxonomies'

    within '#assigned-taxonomies' do
      expect(page).not_to have_content "- #{taxonomy.title}"
      expect(page).to have_content 'None'
    end

    within '#potential-taxonomies' do
      expect(page).to have_content "+ #{taxonomy.title}"
      expect(page).not_to have_content 'None'
    end
  end
end
