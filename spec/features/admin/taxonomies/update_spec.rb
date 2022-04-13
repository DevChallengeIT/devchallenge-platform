# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxonomies/Update' do
  let!(:taxonomy) { create(:taxonomy) }

  it 'failure without session' do
    visit "/admin/taxonomies/#{taxonomy.slug}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/taxonomies/#{taxonomy.slug}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/edit"

    fill_in 'Title', with: ''
    click_button 'Update'

    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}"
    expect(page).not_to have_content 'Taxonomy was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/edit"

    fill_in 'Title', with: 'new title'
    click_button 'Update'

    expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}/taxons"
    expect(page).to have_content 'Taxonomy was successfully updated'
    expect(page).to have_content 'new title'
  end
end
