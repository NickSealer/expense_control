# frozen_string_literal: true

module Queries
  class Base < GraphQL::Schema::Resolver
    include Shared
  end
end
