Rails.application.routes.draw do

  # next 2 lines must be commented for initial rake db:migrate
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :authors, param: :author_id
  resources :areas
  resources :places, param: :place_id
  resources :placerefs, param: :placeref_id
  resources :works, param: :work_id
  resources :passages, param: :passage_id
  resources :search, only: [:index]
  resources :categories #, only: [:index]
  resources :genres, param: :genre_id
  resources :forms, param: :form_id
  resources :communities, param: :communities_id
  resources :standings, param: :standings_id
  resources :images, param: :author_id

  root to: "application#index"

end
