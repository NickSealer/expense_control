# frozen_string_literal: true

class GetOpenaiResponseJob
  include Sidekiq::Job

  sidekiq_options queue: 'openai', retry: 2

  def perform(message_id)
    message = AssistantMessage.find_by(id: message_id)
    call_openai(message)
  end

  private

  def call_openai(message)
    # message.update(message: "#{message.message} Test message from BE Sidekiq job - ")
    client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: messages(message),
        stream: stream_proc(message)
      }
    )
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def messages(message)
    [
      {
        role: 'system',
        content: 'You are a financial consultant, and you are prohibited from giving answers to topics other than finance or administrative management.'
      },
      {
        role: 'user',
        content: message.request
      }
    ]
  end

  def stream_proc(message)
    proc do |chunk|
      new_content = chunk.dig('choices', 0, 'delta', 'content')
      message.update(message: message.message + new_content) if new_content
    end
  end
end
