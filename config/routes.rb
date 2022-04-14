# frozen_string_literal: true

Rails.application.routes.draw do
  resources :news_items
  resources :tours
  resources :point_of_interests
  resources :events
  resources :waste_calendar
  resources :jobs
  resources :offers
  resources :constructions
  resources :surveys
  get "/surveys/:survey_id/comments", to: "survey_comments#index", as: :survey_comments
  resources :encounters_supports, only: [:index, :show]
  post "/encounters_supports/validate", to: "encounters_supports#validate"
  get "/encounters_supports/:id/verify/:user_id", to: "encounters_supports#verify_user", as: :encounters_supports_verify_user
  get "/data_provider", to: "data_provider#edit"
  get "/visibility/:item_type/:id/:visible", to: "data_provider#visibility"
  get "/visibility/:item_type/:id/:visible/:parent_id", to: "data_provider#visibility"
  patch "/data_provider", to: "data_provider#update"
  match "/login", to: "session#create", as: :log_in, via: %i[get post]
  get "/logout", to: "session#destroy"
  get "dashboard/index"
  resources :static_contents, except: :destroy, param: :name
  delete "/static_contents/:id", to: "static_contents#destroy"

  get "/minio/signed_url", to: "minio#signed_url"

  root "dashboard#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
