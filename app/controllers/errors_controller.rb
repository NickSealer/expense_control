# frozen_string_literal: true

class ErrorsController < ApplicationController
  # protect_from_forgery with: :null_session
  layout 'errors'

  def not_found
    render status: :not_found
  end
end
