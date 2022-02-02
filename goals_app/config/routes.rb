Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:new, :index, :show, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :goals, only: [:new, :create, :show, :destroy] do
    member do
      post 'toggle_completed'
    end
  end
end
