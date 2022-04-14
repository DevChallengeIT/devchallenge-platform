# frozen_string_literal: true

module Admin
  class TaxonomyRepoController < BaseController
    helper_method :repo, :repo_title, :repo_path

    add_breadcrumb(proc { |ctx| ctx.repo_title }, proc { |ctx| ctx.repo_path })
    add_breadcrumb(I18n.t('resources.taxonomies.plural'))

    def index
      @assigned_taxonomy_repos = Repo::TaxonomyRepo.where(repo:).preload(:taxonomy)
      @potential_taxonomies = Repo::Taxonomy.where.not(id: @assigned_taxonomy_repos.map(&:taxonomy_id))
    end

    def create
      Repo::TaxonomyRepo.create(repo:, taxonomy:)
      redirect_to repo_taxonomies_path
    end

    def destroy
      Repo::TaxonomyRepo.find(params[:taxonomy_repo_id]).delete
      redirect_to repo_taxonomies_path
    end

    private

    def repo
      params.require(:repo)
    end

    def repo_title
      I18n.t("resources.#{repo}.plural")
    end

    def repo_path
      case repo
      when :challenges then admin_challenges_path
      else
        admin_path
      end
    end

    def repo_taxonomies_path
      "/admin/#{repo}/taxonomies"
    end

    def taxonomy
      @taxonomy ||= Repo::Taxonomy.find(params[:taxonomy_id])
    end
  end
end
