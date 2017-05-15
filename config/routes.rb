Rails.application.routes.draw do
  namespace :cms do
    get '/watting_bookings' => 'bookings#watting_bookings', as: :watting_bookings
    resources :allow_ip_addresses
    post '/allow_ip_addresses' => 'allow_ip_addresses#create', as: :create_allow_ip
    resources :image_room_tops, only: [:index, :update]
    put '/cms/update_image_room_tops' => 'image_room_tops#update', as: :update_image_room_tops
    resources :room_cannot_chooses
    root 'sessions#new'
    resources :services
    resources :bookings do
      resources :booking_services
    end
    get '/booking_services' => 'booking_services#index', as: :all_booking_services
    delete 'room_cannot_chooses/all/delete_all' => 'room_cannot_chooses#destroy_all', as: :room_cannot_chooses_all
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
    put 'bookings/:booking_id/services' => 'booking_services#paid_all', as: :paid_all_services
    get 'all_rooms/bookings' => 'rooms#index_bookings', as: :bookings_all_rooms
    put '/booking/:id/booking_pay' => 'bookings#pay', as: :booking_pay
  end

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get 'index' => 'homepages#index'
    get '/homepages/event' => 'homepages#event', as: :home_event
    resources :bookings, only: %w[new create show]
    resources :rooms, only: %w[show index]
    resources :customers
    root 'homepages#home'
  end
    resources :booking_verifies, only: :edit
    get '/booking/verify/success' => 'booking_verifies#success'
    get 'bookings/:id/watting_verify' => 'booking_verifies#watting_verify', as: :booking_watting_verify
  # get 'homepages/booking', to: 'homepages#booking'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
