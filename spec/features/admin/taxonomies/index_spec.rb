# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxonomies/Index' do
  it 'failure without session' do
    visit '/admin/taxonomies'

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit '/admin/taxonomies'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    taxonomy = create(:taxonomy)

    assume_logged_in(admin: true)
    visit '/admin/taxonomies'

    within "#taxonomy-#{taxonomy.id}" do
      expect(page).to have_link taxonomy.title, href: "/admin/taxonomies/#{taxonomy.slug}/taxons"
    end
  end

  it 'handles pagination' do
    taxonomy_a = create(:taxonomy)
    taxonomy_b = create(:taxonomy)

    assume_logged_in(admin: true)
    visit '/admin/taxonomies?per_page=1'

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/admin/taxonomies?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/admin/taxonomies?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#taxonomy-#{taxonomy_a.id}"
    expect(page).not_to have_css "#taxonomy-#{taxonomy_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path '/admin/taxonomies?per_page=1&page=2'
    end

    expect(page).to have_css "#taxonomy-#{taxonomy_b.id}"
    expect(page).not_to have_css "#taxonomy-#{taxonomy_a.id}"
  end
end
