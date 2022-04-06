# frozen_string_literal: true

module Admin
  class TaxonomiesController < BaseController
    helper_method :taxonomy

    def index
      @paginator, @taxonomies = paginate Repo::Taxonomy.all
    end
  end
end
