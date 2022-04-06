# frozen_string_literal: true

module Admin
  class TaxonsController < BaseController
    helper_method :taxonomy, :taxon

    def index
      @paginator, @taxons = paginate taxonomy.taxons
    end

    def new
      @taxon = Repo::Taxon.new
    end

    def create
      @taxon = Repo::Taxon.new(taxon_params.merge(taxonomy_id: taxonomy.id))

      if taxon.save
        redirect_to(admin_taxonomy_taxons_path(taxonomy), notice: flash_message(:created, :taxons))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if taxon.update(taxon_params)
        redirect_to(admin_taxonomy_taxons_path(taxonomy), notice: flash_message(:updated, :taxons))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def taxon
      @taxon ||= taxonomy.taxons.friendly.find(params[:id])
    end

    def taxonomy
      @taxonomy ||= Repo::Taxonomy.friendly.find(params[:taxonomy_id])
    end

    def taxon_params
      params.require(:taxon).permit(:title)
    end
  end
end
