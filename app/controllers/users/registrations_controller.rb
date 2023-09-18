# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    invisible_captcha only: [:create]
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    def create
      super do |resource|
        unless resource.active?
          sign_out
          redirect_to after_sign_out_path_for(resource) and return
        end
      end
    end

    def update
      avatar = params[:user][:avatar]
      @user.avatar.attach(avatar) if avatar.present? && Category::IMAGE_TYPES.include?(File.extname(avatar.original_filename))

      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      resource_updated = update_resource(resource, account_update_params)
      yield resource if block_given?
      if resource_updated
        set_flash_message_for_update(resource, prev_unconfirmed_email)
        bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

        respond_with resource, location: edit_user_registration_url(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar name])
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
end
