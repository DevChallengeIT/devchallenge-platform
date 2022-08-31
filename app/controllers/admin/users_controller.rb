# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    helper_method :user

    add_breadcrumb I18n.t('resources.users.plural'), :admin_users_path

    def index
      @paginator, @users = paginate Users.list_users(search: params[:search])
    end

    def new
      add_breadcrumb I18n.t('words.new')

      @user = Repo::User.new
    end

    def create
      @user = Repo::User.new(user_params)

      if user.save
        redirect_to(edit_admin_user_path(user), notice: flash_message(:created, :users))
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      add_breadcrumb user.email
    end

    def update
      if user.update(user_params)
        redirect_to(admin_users_path, notice: flash_message(:updated, :users))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      user.destroy
      redirect_to(admin_users_path, notice: flash_message(:removed, :users))
    end

    def log_in_as
      sign_in(:user, user)
      redirect_to root_url
    end

    private

    def user
      @user ||= Repo::User.friendly.find(params[:id] || params[:user_id])
    end

    def user_params
      params.require(:user).permit(:email, :full_name, :password,
                                   :password_confirmation, :time_zone, :slug)
    end
  end
end
