# frozen_string_literal: true

class PersonalAccountingSchema < GraphQL::Schema
  # List of the symbols you can provide to the only option:
  # :login
  # :logout
  # :register
  # :update_password_with_token
  # :send_password_reset_with_token
  # :resend_confirmation_with_token
  # :confirm_registration_with_token

  use GraphqlDevise::SchemaPlugin.new(
    query: Types::QueryType,
    mutation: Types::MutationType,
    resource_loaders: [
      GraphqlDevise::ResourceLoader.new(User, only: %i[login confirm_registration_with_token])
    ]
  )

  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, _obj, _ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, _type_definition, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
