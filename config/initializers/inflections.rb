# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'UI'
  inflect.acronym 'API'
  inflect.uncountable %w[UI API]
end
