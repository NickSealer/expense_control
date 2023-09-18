# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      # self.resource = warden.authenticate!(auth_options)
      # set_flash_message!(:notice, :signed_in)
      # sign_in(resource_name, resource)
      # yield resource if block_given?
      # respond_with resource, location: after_sign_in_path_for(resource)
      super do |resource|
        unless resource.active?
          sign_out
          respond_to_on_destroy and return
        end
      end
    end
  end
end
