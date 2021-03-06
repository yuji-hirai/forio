Rails.application.routes.draw do
  devise_for :users, :controllers => {
  :registrations => 'users/registrations',
  :sessions => 'users/sessions'
  }

  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
  end
	get "users/show" => "users#show"

  root "home#top"

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
end
