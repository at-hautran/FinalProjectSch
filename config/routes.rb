Rails.application.routes.draw do
  # scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  # end

  namespace :cms do
    root 'sessions#new'
    resources :services
    resources :bookings do
      resources :booking_services
    end
    post '/bookings_services/:id' => 'booking_services#update', as: :update_booking_services
    resources :users
    resources :sessions
    resources :rooms
    resources :customers
    resources :top_images
    get 'histories/bookings' => 'bookings#history_index'
    get 'histories/bookings/:id' => 'bookings#histories'
    get 'bookings/:id/bill' => 'bookings#bill', as: :room_bill
    get 'csv_bill', to: 'bookings#csv_bills', as: :foo_export
    get 'customers/:id/bookings' => 'customers#bookings'
    # get 'histories/bookings' => 'bookings#history_index'
    # get 'histories/bookings/:id' => 'bookings#histories'
    get 'top_image_chooses' => 'top_images#edit_top_image_chooseds'
    put 'top_images_chooses' => 'top_images#update_top_image_chooses', as: :update_top_image_chooses
    get 'allrooms/bookings' => 'rooms#all_bookings'
    # put 'top_images_chooses' => 'top_images#update_top_image_chooses', as: :update_top_image_choose
    get 'rooms/:id/bookings' => 'rooms#bookings'
    get 'bookings/:id/new_services' => 'bookings#new_services', as: :booking_new_services
    post 'bookings/:booking_id/create_services/:service_id' => 'bookings#create_services', as: :booking_services
  end

  get 'index' => 'homepages#index'
  get '/booking/verify/success' => 'booking_verifies#success'
  get 'bookings/:id/watting_verify' => 'booking_verifies#watting_verify', as: :booking_watting_verify
  resources :booking_verifies, only: :edit
  resources :bookings, only: %w[new create show]
  resources :rooms, only: %w[show index]
  resources :customers
  root 'homepages#home'
  # get 'homepages/booking', to: 'homepages#booking'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
