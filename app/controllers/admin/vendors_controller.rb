# frozen_string_literal: true

module Admin
  class VendorsController < BaseController
    helper_method :vendor

    add_breadcrumb I18n.t('resources.vendors.plural'), :admin_vendors_path

    def index
      @paginator, @vendors = paginate Repo::Vendor.all
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @vendor = Repo::Vendor.new
    end

    def create
      @vendor = Repo::Vendor.new(vendor_params)

      if vendor.save
        redirect_to(admin_vendors_path, notice: flash_message(:created, :vendors))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb vendor.name
    end

    def update
      if vendor.update(vendor_params.compact_blank)
        redirect_to(admin_vendors_path, notice: flash_message(:updated, :vendors))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def vendor
      @vendor ||= Repo::Vendor.find(params[:id] || params[:vendor_id])
    end

    def vendor_params
      params.require(:vendor).permit(:name)
    end
  end
end
