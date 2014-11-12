Rails.application.routes.draw do

  root 'pitches#index'
  get '/login' => 'sessions#new'
  resource :session, only: [:create, :destroy]
  resources :users
  resources :stories do
    resources :pitches
  end

  get '/pitches' => 'pitches#index'
  get '/profile' => 'sessions#index'
  get '/admin/users' => 'users#index'
  get '/pitches/individual' => 'pitches#individual'
  get '/pitches/business' => 'pitches#business'
  get '/all_stories' => 'stories#all_stories'
  post '/pitches/search' => 'pitches#search'







end
