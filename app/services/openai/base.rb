# frozen_string_literal: true

module Openai
  class Base < ApplicationService
    def model
      'gpt-3.5-turbo'
    end

    def financial_consultant_role
      {
        role: 'system',
        content: 'You are a financial consultant, and you are prohibited from giving answers to topics other than finance or administrative management.'
      }
    end

    private

    def client
      @client ||= OpenAI::Client.new
    end
  end
end
