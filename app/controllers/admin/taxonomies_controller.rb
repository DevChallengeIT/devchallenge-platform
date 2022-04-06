# frozen_string_literal: true

module Admin
  class TaxonomiesController < BaseController
    helper_method :taxonomy

    add_breadcrumb I18n.t('resources.taxonomies.plural'), :admin_taxonomies_path

    def index
      @paginator, @taxonomies = paginate Repo::Taxonomy.all
    end
  end
end
