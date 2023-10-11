# frozen_string_literal: true

Dir[Rails.root.join('lib/custom_errors/**/*.rb')].sort.each { |e| require e }
