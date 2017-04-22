Rails.application.routes.draw do
  namespace :cms do
    root 'sessions#new'
    resources :users
    resources :sessions
    resources :rooms
  end
  resources :rooms, only: %w[show index]
  resources :customers, only: %w[show index]
  root 'homepages#home'
  # get 'homepages/booking', to: 'homepages#booking'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
