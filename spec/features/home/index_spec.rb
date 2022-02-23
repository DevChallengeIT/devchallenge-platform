# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page' do
  it 'works' do
    visit '/'
    expect(page).to have_content 'Hello, DevChallenge!'
  end
end
