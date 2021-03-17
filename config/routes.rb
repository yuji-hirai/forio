Rails.application.routes.draw do
  root "home#top"
  get 'likes/index' => 'likes#index'
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'

  devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions',
  omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    post 'guest_sign_in' => 'users/sessions#new_guest'
    get "sign_in" => "users/sessions#new"
    get "sign_out" => "users/sessions#destroy"
  end

  resources :users, :only => :show do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: [:index, :destroy]

  resources :posts do
    resources :comments, :only => [:create, :destroy]
  end


end
