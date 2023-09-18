# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include NavbarAcctions
  before_action :years

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url, notice: 'Resource not found.'
  end
end
