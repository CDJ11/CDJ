require_dependency Rails.root.join('app', 'controllers', 'admin', 'users_controller').to_s

class Admin::UsersController < Admin::BaseController

  before_action :find_user, only: [:cdj_show, :print_password, :reset_password, :change_password]

  def index
    @users = User.by_username_email_or_document_number(params[:search]) if params[:search]
    all_users = @users.active
    @users = @users.page(params[:page])
    respond_to do |format|
      format.html
      format.js
      format.csv {
        send_data all_users.to_csv
      }
    end
  end

  def cdj_show
  end

  def print_password
  end

  def reset_password
    @user.send_reset_password_instructions
    redirect_to cdj_show_admin_user_path(@user), notice: t("management.account.edit.password.reset_email_send")
  end

  def change_password
    if @user.reset_password(params[:user][:password], params[:user][:password])
      session[:new_password] = params[:user][:password]
      redirect_to cdj_show_admin_user_path(@user), notice: "Le mot de passe a bien été réinitialisé"
    else
      render :cdj_show
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

end
