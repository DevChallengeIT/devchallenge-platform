# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxonomy/Create' do
  it 'failure without session' do
    visit '/admin/taxonomies/new'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/taxonomies/new'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit '/admin/taxonomies/new'

    fill_in 'Title', with: ''
    click_button 'Create'

    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path '/admin/taxonomies'
    expect(page).not_to have_content 'Taxon was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit '/admin/taxonomies/new'

    fill_in 'Title', with: 'New Taxonomy'
    click_button 'Create'

    expect(page).to have_current_path '/admin/taxonomies'
    expect(page).to have_content 'Taxonomy was successfully created'
    expect(page).to have_content 'New Taxonomy'
  end
end
