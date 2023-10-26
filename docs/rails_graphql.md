# Build a GraphQL API in Ruby on Rails
Implement a GraphQl API to an existing app.\
At the beginning you might see `current_user`, this method is only available in authenticable API.\
Later I'll explain how to implement [session manage](#session-manage). 

## Content

- [Basic steps](#basic-steps)
- [Object Type](#object-type)
  - [Association fields](#association-fields)
  - [Custom fields](#custom-fields)
- [Query Type](#query-type)
  - [Resolvers](#resolvers)
    - [List](#list)
    - [Show](#show)
- [Input Type](#input-type)
- [Mutation Type](#mutation-type)
  - [Create](#create)
  - [Update](#update)
  - [Delete](#delete)
- [Session manage](#session-manage)
  - [Config Steps](#config-steps)
  - [Authenticating Controller Actions](#authenticating-controller-actions)
  - [Signup](#signup)
  - [Login](#login)
  - [Logout](#logout)


## Basic steps:
1. install:
  ```
  gem 'graphql'
  gem 'graphiql-rails', group: :development
  ```
2. Then run:
  ```
  rails generate graphql:install
  ```
3. Mounting routes:
  ```ruby
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  post '/graphql', to: 'graphql#execute'
  ```
4. Generating Object types:
  ```
  rails generate graphql:object Category
  ```
5. All query request are managed through graphql_controller #execute method.

## Object Type
Describe objects in your app, accesible fields and associations.\
`app/graphql/types/category_type.rb`

```ruby
module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :parent_id, Integer
    field :user_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
```
#### Association fields
```ruby
field :user, Types::UserType, null: false # Belongs to association
field :expenses, [Types::ExpenseType], null: true # Has many association
```
#### Custom fields
```ruby
field :parent, Types::CategoryType, null: true # Self association

def parent
  object.parent # This can be any custom value
end
```
> Hint: A short way to define a non-nullable field:
```ruby
field :name, String!
```

## Query Type
Define the entry point to fetch data (GET action in REST) `app/graphql/types/query_type.rb`:

```ruby
module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    #Use resolvers instead to add the code here
    field :categories, resolver: Queries::Categories::List
    field :category, resolver: Queries::Categories::Show
  end
end
```
### Resolvers
Is a container for field signature and resolution logic.

#### List
Create the resolver `app/graphql/queries/categories/list.rb`
```ruby
module Queries
  module Categories
    class List < Queries::Base
      type [Types::CategoryType], null: false # Returned type

      def resolve
        current_user.categories
      end
    end
  end
end
```
#### Show
Create the resolver `app/graphql/queries/categories/show.rb`
```ruby
module Queries
  module Categories
    class Show < Queries::Base
      type Types::CategoryType, null: false # Returned type
      argument :id, ID, required: true # Argument to work

      def resolve(id:)
        current_user.categories.find_by(id: id)
      end
    end
  end
end
```

### Quering data
> Hint:\
Use `camelCase` to reference a field.\
`query` word is optional.

#### List categories
```
query {
  categories {
    name
    description
    parentId
    user {
      name
      email
      lastSignInAt
    }
  }
}
```
#### Get category
```
{
  category(id: 1) {
    name
    description
    parentId
    user {
      name
      email
      lastSignInAt
    }
  }
}
```

## Input Type
Optional class to define required fields to create an object and custom validations.\
It's required convert them to Hash type in the MutationType class.\
The fields can be defined into the MutationType class.

> Hint: They act as strong parameters.

`app/graphql/types/inputs/category.rb`
```ruby
module Types
  module Inputs
    class Category < Types::BaseInputObject
      argument :name, String, required: true
      argument :description, String, required: true
      argument :parent_id, ID, required: false
    end
  end
end
```

## Mutation Type
Define the entry point to modify data (CREATE, UPDATE, DELETE actions in REST).

`app/graphql/types/mutation_type.rb`
```ruby
module Types
  class MutationType < Types::BaseObject
    field :create_category, mutation: Mutations::Categories::Create
    field :update_category, mutation: Mutations::Categories::Update
    field :delete_category, mutation: Mutations::Categories::Delete
  end
end
```

> Hint:\
Use 'field_camel_case' in **UPDATE** action.\
Use 'fieldCamelCase' in **CREATE** action.

### Create
Create mutation `app/graphql/mutations/categories/create.rb`

```ruby
module Mutations
  module Categories
    class Create < BaseMutation
      field :category, Types::CategoryType, null: false # Returned field
      argument :params, Types::Inputs::Category, required: true # InputType approach

      def resolve(params:)
        category = current_user.categories.create!(Hash(params))

        { category: category }
      end
    end
  end
end
```
Create category:
```
mutation {
  createCategory(input: {
    params: {
      name: "Test category name"
      description: "Test category description. Awesome category!!"
    }
  })
  {
    category{
      id
      name
      description
    }
  }
}
```
### Update
Create mutation `app/graphql/mutations/categories/update.rb`

```ruby
module Mutations
  module Categories
    class Update < BaseMutation
      field :category, Types::CategoryType, null: false # Returned field
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true # Antother approach instead of InputType

      def resolve(id:, params:)
        category = current_user.categories.find_by(id: id)
        category&.update!(params)

        { category: category }
      end
    end
  end
end
```
Update category:
```
mutation {
  updateCategory(input: {id: 1
    params: {
      name: "Update name."
    }
  })
  {
    category{
      id
      name
      description
    }
  }
}
```
### Delete
Create mutation `app/graphql/mutations/categories/delete.rb`

```ruby
module Mutations
  module Categories
    class Delete < BaseMutation
      field :category, Types::CategoryType, null: false # Returned field
      argument :id, ID, required: true

      def resolve(id:)
        category = current_user.categories.find_by(id: id)
        category&.destroy

        { category: category }
      end
    end
  end
end
```
Delete category:
```
mutation {
  deleteCategory(input: {id: 1}){
    category {
      id
      name
    }
  }
}
```

## Session manage
This manual is only to install session manage to a GraphQL API.\
I've used [GraphQL Devise](https://github.com/graphql-devise/graphql_devise) to manage user sessions and gem [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth)

### Config steps:
1. Intall:
```
gem 'devise_token_auth', '~> 1.2.2'
gem 'graphql_devise', '~> 1.3'
```
2. Run generator:
```
rails generate graphql_devise:install
```
3. Mounting routes:
```ruby
mount_graphql_devise_for User, at: 'graphql_auth'
```
4. Inlude the module in User model just after devise methods:
```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  include GraphqlDevise::Authenticatable
end
```
5. Mount gem's operations to the schema:
```ruby
use GraphqlDevise::SchemaPlugin.new(
  query: Types::QueryType,
  mutation: Types::MutationType,
  resource_loaders: [
    GraphqlDevise::ResourceLoader.new(User, only: %i[login]) # Mount available mutations. Complete list is in the gem documentation.
  ]
)
```
6. Updating Query Type:\
Add `field_class GraphqlDevise::Types::BaseField` to support graphql-ruby v2.
```ruby
module Types
  class QueryType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField
  end
end
```
7. Updating Mutation Type:\
Add `field_class GraphqlDevise::Types::BaseField` to support graphql-ruby v2.
```ruby
module Types
  class MutationType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField
  end
end
```

## Authenticating controller actions
Adjust your default controller whit these lines:
```
include GraphqlDevise::SetUserByToken
```
```
YourSchema.execute(params[:query], context: gql_devise_context(User))
```
```
render json: result unless performed?
```

Your controller should look like this:
```ruby
class GraphqlController < ApplicationController
  include GraphqlDevise::SetUserByToken

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = gql_devise_context(User)
    context[:headers] = request.headers

    result = PersonalAccountingSchema.execute(
      query, variables: variables, context: context, operation_name: operation_name
    )
    render json: result unless performed?
  end
end
```

## Signup
You can signup using the userRegister mutation or create your own mutation:
```
userRegister(email: String!, password: String!, passwordConfirmation: String!, confirmUrl: String): UserRegisterPayload
```

I used my own createUser mutation as my signup action. This is the only query that won't ask authentication headers.
```ruby
field :create_user, mutation: Mutations::Users::Create, authenticate: false
```

## Login
Once the request is done, you have to send the credetials through headers

```
mutation {
  userLogin(email: "email", password: "password"){
    credentials {
      accessToken
      client
      uid
      expiry
      tokenType
    }
  }
}
```

```
{
  categories() {
    name
    description
  }
}
```

**Headers**
```
{
  "uid": "uid",
  "client": "client",
  "access-token": "access-token"
}
```
## Logout

I made my own logout mutation 'cause the gem's mutation never worked in my app.\
Create logout mutation `app/graphql/mutations/sessions/logout.rb`
```ruby
module Mutations
  module Sessions
    class Logout < BaseMutation
      field :response, String, null: true
      argument :id, ID, required: true

      def resolve(id:)
        current_user.tokens.delete(client)
        current_user.save!
        remove_resource

        { response: 'Session finished.' }
      end

      private

      def controller
        @controller ||= context[:controller]
      end

      def remove_resource
        controller.resource = nil
        controller.client_id = nil
        controller.token = nil
      end
    end
  end
end
```

I created a Shared concern, included in `app/graphql/queries/base.rb` and `app/graphql/mutations/base_mutation.rb`
```ruby
module Shared
  extend ActiveSupport::Concern

  included do
    def client
      @client ||= context[:headers][:client]
    end

    def current_user
      @current_user ||= context[:current_resource]
    end
  end
end
```

Finally, the logout query:
```
mutation {
  logout(input: {id: 1}) {
    response
  }
}
```
