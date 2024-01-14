# frozen_string_literal: true

Rails.application.routes.draw do
  mount_graphql_devise_for User, at: 'graphql_auth'
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

  resources :categories do
    collection do
      get :search
    end
  end

  resources :notifications, only: [] do
    member do
      get :read
      put :update
      delete :destroy
    end
  end

  controller :exports do
    get :export
    get :data_to_csv
  end

  # OpenAI
  resources :assistant_messages, only: %i[create]

  # API
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'

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
#                             graphql_auth POST     /graphql_auth(.:format)                                                                           graphql_devise/graphql#auth
#                                          GET      /graphql_auth(.:format)                                                                           graphql_devise/graphql#auth
#                           graphiql_rails          /graphiql                                                                                         GraphiQL::Rails::Engine {:graphql_path=>"/graphql"}
#                                  graphql POST     /graphql(.:format)                                                                                graphql#execute
#                         new_user_session GET      /users/sign_in(.:format)                                                                          users/sessions#new
#                             user_session POST     /users/sign_in(.:format)                                                                          users/sessions#create
#                     destroy_user_session DELETE   /users/sign_out(.:format)                                                                         users/sessions#destroy
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
#    user_google_oauth2_omniauth_authorize GET|POST /omniauth/google_oauth2(.:format)                                                                 users/omniauth_callbacks#passthru
#     user_google_oauth2_omniauth_callback GET|POST /omniauth/google_oauth2/callback(.:format)                                                        users/omniauth_callbacks#google_oauth2
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
#                                   export GET      /export(.:format)                                                                                 exports#export
#                              data_to_csv GET      /data_to_csv(.:format)                                                                            exports#data_to_csv
#                       assistant_messages POST     /assistant_messages(.:format)                                                                     assistant_messages#create
#                  new_api_v1_user_session GET      /api/v1/auth/sign_in(.:format)                                                                    devise_token_auth/sessions#new
#                      api_v1_user_session POST     /api/v1/auth/sign_in(.:format)                                                                    devise_token_auth/sessions#create
#              destroy_api_v1_user_session DELETE   /api/v1/auth/sign_out(.:format)                                                                   devise_token_auth/sessions#destroy
#                 new_api_v1_user_password GET      /api/v1/auth/password/new(.:format)                                                               devise_token_auth/passwords#new
#                edit_api_v1_user_password GET      /api/v1/auth/password/edit(.:format)                                                              devise_token_auth/passwords#edit
#                     api_v1_user_password PATCH    /api/v1/auth/password(.:format)                                                                   devise_token_auth/passwords#update
#                                          PUT      /api/v1/auth/password(.:format)                                                                   devise_token_auth/passwords#update
#                                          POST     /api/v1/auth/password(.:format)                                                                   devise_token_auth/passwords#create
#          cancel_api_v1_user_registration GET      /api/v1/auth/cancel(.:format)                                                                     devise_token_auth/registrations#cancel
#             new_api_v1_user_registration GET      /api/v1/auth/sign_up(.:format)                                                                    devise_token_auth/registrations#new
#            edit_api_v1_user_registration GET      /api/v1/auth/edit(.:format)                                                                       devise_token_auth/registrations#edit
#                 api_v1_user_registration PATCH    /api/v1/auth(.:format)                                                                            devise_token_auth/registrations#update
#                                          PUT      /api/v1/auth(.:format)                                                                            devise_token_auth/registrations#update
#                                          DELETE   /api/v1/auth(.:format)                                                                            devise_token_auth/registrations#destroy
#                                          POST     /api/v1/auth(.:format)                                                                            devise_token_auth/registrations#create
#               api_v1_auth_validate_token GET      /api/v1/auth/validate_token(.:format)                                                             devise_token_auth/token_validations#validate_token
#                      api_v1_auth_failure GET|POST /api/v1/auth/failure(.:format)                                                                    devise_token_auth/omniauth_callbacks#omniauth_failure
#                                          GET|POST /api/v1/auth/:provider/callback(.:format)                                                         devise_token_auth/omniauth_callbacks#omniauth_success
#                                          GET|POST /omniauth/:provider/callback(.:format)                                                            devise_token_auth/omniauth_callbacks#redirect_callbacks
#                         omniauth_failure GET|POST /omniauth/failure(.:format)                                                                       devise_token_auth/omniauth_callbacks#omniauth_failure
#                                          GET|POST /api/v1/auth/:provider(.:format)                                                                  redirect(307)
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
#            rails_postmark_inbound_emails POST     /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST     /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST     /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET      /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST     /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST     /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET      /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST     /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET      /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#       edit_rails_conductor_inbound_email GET      /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                                 rails/conductor/action_mailbox/inbound_emails#edit
#            rails_conductor_inbound_email GET      /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT      /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE   /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
# new_rails_conductor_inbound_email_source GET      /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST     /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST     /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST     /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET      /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET      /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET      /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET      /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET      /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET      /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET      /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT      /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST     /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for GraphiQL::Rails::Engine:
#        GET  /           graphiql/rails/editors#show
