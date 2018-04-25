require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    if resource.valid?
      super
    else
      render :new
    end
  end


  private

    def sign_up_params
      params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
      params.require(:user).permit(:username, :email, :password,
                                   :password_confirmation, :terms_of_service, :locale,
                                   :redeemable_code,
                                   :firstname, :lastname, :date_of_birth, :gender,
                                   :address, :postal_code, :city, :phone_number, :ca_wanabee)
                            .merge(residence_verified_at: Time.zone.now, verified_at: Time.zone.now,
                                  level_two_verified_at: Time.zone.now, confirmed_phone: params[:user][:phone_number])
    end


end
