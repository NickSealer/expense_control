# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "#{ENV['APP_HOST']}:#{ENV['APP_PORT']}"
    resource '*', # '/api/v1/*', '^(graphql)+(.{0,})$',
             headers: %w[access-token uid client],
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post put patch delete]
  end
end
