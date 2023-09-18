# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!, :user
  skip_before_action :verify_authenticity_token, only: %i[update destroy]

  def read
    notification.read! unless notification.read
    render json: { notification: notification }, status: :ok
  end

  def update
    notification.read! unless notification.read
    render json: { notification: notification }, status: :ok
  end

  def destroy
    notification.destroy!
    render json: { notification: notification }, status: :ok
  end

  private

  def user
    return if current_user.id != params[:user].to_i

    @user ||= User.find(params[:user])
  end

  def notification
    user.notifications.find_by(id: params[:id])
  end
end
