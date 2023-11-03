Rails.application.routes.draw do
  devise_for :users
  resources :company do
    member do
      get :chat_testing
    end
    resources :invites
    resources :data
    resources :chat do
      get :chat
      post :create
    end
    resources :products do
      get :new
      post :create
      post :create_completions
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "presentation#index"
end
