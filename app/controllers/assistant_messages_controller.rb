# frozen_string_literal: true

class AssistantMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.assistant_messages.create(
      request: assistant_message_params[:content],
      user_id: current_user.id
    )

    GetOpenaiResponseJob.perform_async(@message.id)

    respond_to(&:turbo_stream)
  end

  private

  def assistant_message_params
    params.require(:assistant_message).permit(:content)
  end
end
