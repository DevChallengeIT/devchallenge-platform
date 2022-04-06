# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::PaginatorComponent, type: :component do
  let(:paginator) { Pagy.new count: 50, page: 1 }

  it 'renders list of errors' do
    render_inline(described_class.new(paginator:))

    expect(rendered_component).to be_present # :)
  end
end
