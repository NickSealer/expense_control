# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  post '/graphql', to: 'graphql#execute'

  require 'sidekiq/web'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  authenticate :user do
    mount Sidekiq::Web => 'user/sidekiq'
  end

  # resources :posts
  root 'expenses#new'

  resources :expenses do
    collection do
      get :import_csv_form
      get :download_csv
      post :import_csv
      get :summary
      get :summary_details
      get :send_monthly_report
    end
  end

  resources :budgets
  resources :categories
  resources :notifications, only: [] do
    member do
      get :read
      put :update
      delete :destroy
    end
  end

  # OpenAI
  resources :assistant_messages, only: %i[create]

  controller :exports do
    get :export
    get :data_to_csv
  end

  # API
  namespace 'api' do
    namespace 'v1' do
      resources :expenses, only: %i[index show] do
        collection do
          get :search
        end
      end
      resources :categories, only: %i[index show] do
        collection do
          get :search
        end
      end
    end
  end

  match '/404', to: 'errors#not_found', via: :all
end

# == Route Map
#
#                                   Prefix Verb     URI Pattern                                                                                       Controller#Action
#                           graphiql_rails          /graphiql                                                                                         GraphiQL::Rails::Engine {:graphql_path=>"/graphql"}
#                                  graphql POST     /graphql(.:format)                                                                                graphql#execute
#                         new_user_session GET      /users/sign_in(.:format)                                                                          users/sessions#new
#                             user_session POST     /users/sign_in(.:format)                                                                          users/sessions#create
#                     destroy_user_session DELETE   /users/sign_out(.:format)                                                                         users/sessions#destroy
#    user_google_oauth2_omniauth_authorize GET|POST /users/auth/google_oauth2(.:format)                                                               users/omniauth_callbacks#passthru
#     user_google_oauth2_omniauth_callback GET|POST /users/auth/google_oauth2/callback(.:format)                                                      users/omniauth_callbacks#google_oauth2
#                        new_user_password GET      /users/password/new(.:format)                                                                     devise/passwords#new
#                       edit_user_password GET      /users/password/edit(.:format)                                                                    devise/passwords#edit
#                            user_password PATCH    /users/password(.:format)                                                                         devise/passwords#update
#                                          PUT      /users/password(.:format)                                                                         devise/passwords#update
#                                          POST     /users/password(.:format)                                                                         devise/passwords#create
#                 cancel_user_registration GET      /users/cancel(.:format)                                                                           users/registrations#cancel
#                    new_user_registration GET      /users/sign_up(.:format)                                                                          users/registrations#new
#                   edit_user_registration GET      /users/edit(.:format)                                                                             users/registrations#edit
#                        user_registration PATCH    /users(.:format)                                                                                  users/registrations#update
#                                          PUT      /users(.:format)                                                                                  users/registrations#update
#                                          DELETE   /users(.:format)                                                                                  users/registrations#destroy
#                                          POST     /users(.:format)                                                                                  users/registrations#create
#                              sidekiq_web          /user/sidekiq                                                                                     Sidekiq::Web
#                                     root GET      /                                                                                                 expenses#new
#                 import_csv_form_expenses GET      /expenses/import_csv_form(.:format)                                                               expenses#import_csv_form
#                    download_csv_expenses GET      /expenses/download_csv(.:format)                                                                  expenses#download_csv
#                      import_csv_expenses POST     /expenses/import_csv(.:format)                                                                    expenses#import_csv
#                         summary_expenses GET      /expenses/summary(.:format)                                                                       expenses#summary
#                 summary_details_expenses GET      /expenses/summary_details(.:format)                                                               expenses#summary_details
#             send_monthly_report_expenses GET      /expenses/send_monthly_report(.:format)                                                           expenses#send_monthly_report
#                                 expenses GET      /expenses(.:format)                                                                               expenses#index
#                                          POST     /expenses(.:format)                                                                               expenses#create
#                              new_expense GET      /expenses/new(.:format)                                                                           expenses#new
#                             edit_expense GET      /expenses/:id/edit(.:format)                                                                      expenses#edit
#                                  expense GET      /expenses/:id(.:format)                                                                           expenses#show
#                                          PATCH    /expenses/:id(.:format)                                                                           expenses#update
#                                          PUT      /expenses/:id(.:format)                                                                           expenses#update
#                                          DELETE   /expenses/:id(.:format)                                                                           expenses#destroy
#                                  budgets GET      /budgets(.:format)                                                                                budgets#index
#                                          POST     /budgets(.:format)                                                                                budgets#create
#                               new_budget GET      /budgets/new(.:format)                                                                            budgets#new
#                              edit_budget GET      /budgets/:id/edit(.:format)                                                                       budgets#edit
#                                   budget GET      /budgets/:id(.:format)                                                                            budgets#show
#                                          PATCH    /budgets/:id(.:format)                                                                            budgets#update
#                                          PUT      /budgets/:id(.:format)                                                                            budgets#update
#                                          DELETE   /budgets/:id(.:format)                                                                            budgets#destroy
#                               categories GET      /categories(.:format)                                                                             categories#index
#                                          POST     /categories(.:format)                                                                             categories#create
#                             new_category GET      /categories/new(.:format)                                                                         categories#new
#                            edit_category GET      /categories/:id/edit(.:format)                                                                    categories#edit
#                                 category GET      /categories/:id(.:format)                                                                         categories#show
#                                          PATCH    /categories/:id(.:format)                                                                         categories#update
#                                          PUT      /categories/:id(.:format)                                                                         categories#update
#                                          DELETE   /categories/:id(.:format)                                                                         categories#destroy
#                        read_notification GET      /notifications/:id/read(.:format)                                                                 notifications#read
#                             notification PUT      /notifications/:id(.:format)                                                                      notifications#update
#                                          DELETE   /notifications/:id(.:format)                                                                      notifications#destroy
#                       assistant_messages POST     /assistant_messages(.:format)                                                                     assistant_messages#create
#                                   export GET      /export(.:format)                                                                                 exports#export
#                              data_to_csv GET      /data_to_csv(.:format)                                                                            exports#data_to_csv
#                   search_api_v1_expenses GET      /api/v1/expenses/search(.:format)                                                                 api/v1/expenses#search
#                          api_v1_expenses GET      /api/v1/expenses(.:format)                                                                        api/v1/expenses#index
#                           api_v1_expense GET      /api/v1/expenses/:id(.:format)                                                                    api/v1/expenses#show
#                 search_api_v1_categories GET      /api/v1/categories/search(.:format)                                                               api/v1/categories#search
#                        api_v1_categories GET      /api/v1/categories(.:format)                                                                      api/v1/categories#index
#                          api_v1_category GET      /api/v1/categories/:id(.:format)                                                                  api/v1/categories#show
#                                                   /404(.:format)                                                                                    errors#not_found
#         turbo_recede_historical_location GET      /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET      /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET      /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#
# Routes for GraphiQL::Rails::Engine:
#        GET  /           graphiql/rails/editors#show
