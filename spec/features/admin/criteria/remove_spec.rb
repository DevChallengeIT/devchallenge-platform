# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Criteria/Remove' do
  let(:criterium) { create(:task_criterium) }
  let!(:task) { criterium.task }
  let!(:challenge) { task.challenge }

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria/#{criterium.id}/edit"

    click_button 'Remove'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/criteria"
    expect(page).to have_content 'Criterion was successfully removed'
  end
end
