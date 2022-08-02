# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::ErrorTagComponent, type: :component do
  let(:errors) { { test: ["can't be blank"] } }

  it 'renders list of errors' do
    render_inline(described_class.new(errors:, field: :test))

    expect(page).to have_css "ul > li[class='text-red-500 font-medium']", text: "can't be blank"
  end
end
