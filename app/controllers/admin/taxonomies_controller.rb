# frozen_string_literal: true

module Admin
  class TaxonomiesController < BaseController
    helper_method :taxonomy

    add_breadcrumb I18n.t('resources.taxonomies.plural'), :admin_taxonomies_path

    def index
      @paginator, @taxonomies = paginate Repo::Taxonomy.all
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @taxonomy = Repo::Taxonomy.new
    end

    def create
      @taxonomy = Repo::Taxonomy.new(taxonomy_params)

      if taxonomy.save
        redirect_to(admin_taxonomies_path, notice: flash_message(:created, :taxonomies))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb taxonomy.title
    end

    def update
      if taxonomy.update(taxonomy_params)
        redirect_to(admin_taxonomy_taxons_path(taxonomy), notice: flash_message(:updated, :taxonomies))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def taxonomy_params
      params.require(:taxonomy).permit(:title)
    end

    def taxonomy
      @taxonomy ||= Repo::Taxonomy.friendly.find(params[:id])
    end
  end
end
