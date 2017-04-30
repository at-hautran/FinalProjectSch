Rails.application.routes.draw do
  namespace :cms do
    root 'sessions#new'
    resources :bookings
    resources :users
    resources :sessions
    resources :rooms
  end

  get '/booking/verify/success' => 'booking_verifies#success'
  resources :booking_verifies, only: :edit
  resources :bookings, only: %w[new create show]
  resources :rooms, only: %w[show index]
  resources :customers
  root 'homepages#home'
  # get 'homepages/booking', to: 'homepages#booking'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
