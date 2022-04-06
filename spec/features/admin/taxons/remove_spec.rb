# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Taxons/Remove' do
  let!(:taxonomy) { create(:taxonomy) }
  let!(:taxon) { create(:taxon, taxonomy:) }

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/taxonomies/#{taxonomy.slug}/taxons/#{taxon.slug}/edit"

    click_button 'Remove'

    expect(page).to have_current_path "/admin/taxonomies/#{taxonomy.slug}/taxons"
    expect(page).to have_content 'Taxon was successfully removed'
  end
end
