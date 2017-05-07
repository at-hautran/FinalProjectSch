Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  end
  namespace :cms do
    root 'sessions#new'
    resources :bookings
    resources :users
    resources :sessions
    resources :rooms
    resources :top_images
    get 'histories/bookings' => 'bookings#history_index'
    get 'histories/bookings/:id' => 'bookings#histories'
    get 'top_image_chooses' => 'top_images#edit_top_image_chooseds'
    put 'top_images_chooses' => 'top_images#update_top_image_chooses', as: :update_top_image_chooses
    get 'allrooms/bookings' => 'rooms#all_bookings'
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
