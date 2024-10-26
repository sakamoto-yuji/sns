# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :configure_sign_up_params, only: [:create]
   before_action :configure_account_update_params, only: [:update]

   def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image, :password, :email])
  end

   def user_image_initial_save(user)
     image = sign_up_params[:image] # アップロードされた画像を取得

     if image.present?
       user.image = "#{user.id}.jpg" # ユーザーIDをファイル名に設定
       image_path = "public/user_images/#{user.image}"

       # ディレクトリの存在確認と作成
       FileUtils.mkdir_p(File.dirname(image_path))

     begin
       File.binwrite(image_path, image.read) # 画像を保存
       user.save
     rescue => e
       Rails.logger.error("Image save error: #{e.message}") # エラーロギング
       user.image = "default_image.jpg" # 保存に失敗した場合のデフォルト画像
       user.save
     end
     else
       user.image = "default_image.jpg" # 画像がない場合のデフォルト画像
       user.save
     end
   end


  # GET /resource/sign_up
   def new
     super
   end

  # POST /resource
   def create
     build_resource(sign_up_params)
    resource.valid?(:create)
    resource.save
    @user = resource
    user_image_initial_save(@user)
    yield resource if block_given?
    if resource.persisted?
        if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
          #  respond_with resource, location: after_sign_up_path_for(resource)
            redirect_to(user_path(id: @user.id))
        else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
    else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource, status: :see_other # 登録失敗時のrespond_withにerror出したいので、ここで303 statusを追加
    end
  end

  # GET /resource/edit
   def edit
     super
   end

  # PUT /resource
   def update
     self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      redirect_to(user_path(id: current_user.id))
#      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
   end

   def set_flash_message_for_update(resource, prev_unconfirmed_email)
    return unless is_flashing_format?

    flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                  :update_needs_confirmation
                elsif sign_in_after_change_password?
                  :password_updated
                else
                  :updated_but_not_signed_in
                end
    set_flash_message :notice, flash_key
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
   end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
