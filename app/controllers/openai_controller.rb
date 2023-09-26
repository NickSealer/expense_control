# frozen_string_literal: true

class OpenaiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[chat]

  def chat
    @message = Openai::Chat.execute(openai_params)
    respond_to do |format|
      format.turbo_stream {}
    end
  end

  private

  def openai_params
    params.require(:chatbox).permit(:user, :content)
  end
end
