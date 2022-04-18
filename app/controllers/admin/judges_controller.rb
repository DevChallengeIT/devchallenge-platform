# frozen_string_literal: true

module Admin
  class JudgesController < BaseController
    add_breadcrumb I18n.t('resources.judges.plural'), :admin_judges_path

    def index
      @paginator, @judges = paginate Repo::Member.preload(:user, :challenge).judge
    end
  end
end
