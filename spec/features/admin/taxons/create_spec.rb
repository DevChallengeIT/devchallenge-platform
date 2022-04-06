# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxons/Create' do
  let!(:taxonomy) { create(:taxonomy) }

  it 'failure without session' do
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with invalid params' do
    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons/new"

    fill_in 'Title', with: ''
    click_button 'Create'

    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}/taxons"
    expect(page).not_to have_content 'Taxon was successfully created'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons/new"

    fill_in 'Title', with: 'New Taxon'
    fill_in 'Position', with: '0'
    click_button 'Create'

    expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}/taxons"
    expect(page).to have_content 'Taxon was successfully created'
    expect(page).to have_content '1. New Taxon'
  end
end
