# frozen_string_literal: true

module Openai
  class Chat < Openai::Base
    def initialize(params)
      @params = params
    end

    def execute
      response = client.chat(parameters: parameters)
      @message = response.dig('choices', 0, 'message', 'content')
      save_request
    end

    private

    attr_reader :params, :message

    def parameters
      {
        model: model,
        messages: [financial_consultant_role, user_message]
      }
    end

    def user_message
      {
        role: 'user',
        content: @params[:content]
      }
    end

    protected

    def save_request
      AssistantMessage.create(
        request: params[:content],
        message: message,
        user_id: params[:user]
      )
    end
  end
end
