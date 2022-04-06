# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxons/Index' do
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

  it 'success' do
    taxon = create(:taxon, taxonomy:)

    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons"

    within "#taxon-#{taxon.id}" do
      expect(page).to have_link taxon.title, href: "/admin/taxonomies/#{taxonomy.slug}/taxons/#{taxon.slug}/edit"
    end
  end

  it 'handles pagination' do
    taxon_a = create(:taxon, taxonomy:)
    taxon_b = create(:taxon, taxonomy:)

    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons?per_page=1"

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/taxonomies/#{taxonomy.slug}/taxons?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/taxonomies/#{taxonomy.slug}/taxons?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#taxon-#{taxon_a.id}"
    expect(page).not_to have_css "#taxon-#{taxon_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}/taxons?per_page=1&page=2"
    end

    expect(page).to have_css "#taxon-#{taxon_b.id}"
    expect(page).not_to have_css "#taxon-#{taxon_a.id}"
  end
end
