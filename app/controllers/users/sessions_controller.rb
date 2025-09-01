# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
   before_action :configure_sign_in_params, only: [:create]

   def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
   end

   #GET /resource/sign_in
   def new
     super
   end

   #POST /resource/sign_in
   def create
     self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to after_sign_in_path_for(resource)
   end

   def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to after_sign_in_path_for(user), notice: "ゲストユーザーとしてログインしました。"
   end

   #DELETE /resource/sign_out
   def destroy
     signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    redirect_to(new_user_session_path)
   end

  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name), status: :see_other }
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
