# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :notification

  def read
    notification.read! unless notification.read
    render json: { notification: notification }, status: :ok
  end

  def update
    notification.read! unless notification.read
    respond_to(&:turbo_stream)
  end

  def destroy
    notification.destroy!
    respond_to(&:turbo_stream)
  end

  private

  def notification
    @notification = current_user.notifications.find_by(id: params[:id])
  end
end
