Rails.application.routes.draw do
  get 'paypal/checkout' => 'bookings#paypal_checkout'
  get 'bookings/paypal' => 'bookings#payment_save', as: :payment_save
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
    get 'top_image_chooses' => 'top_images#edit_top_image_chooseds'
    put 'top_images_chooses' => 'top_images#update_top_image_chooses', as: :update_top_image_chooses
    get 'allrooms/bookings' => 'rooms#all_bookings'
    get 'rooms/:id/bookings' => 'rooms#bookings'
    get 'bookings/:id/new_services' => 'bookings#new_services', as: :booking_new_services
    post 'bookings/:booking_id/create_services/:service_id' => 'bookings#create_services', as: :booking_services
    put 'bookings/:booking_id/services' => 'booking_services#paid_all', as: :paid_all_services
    get 'all_rooms/bookings' => 'rooms#index_bookings', as: :bookings_all_rooms
    put '/booking/:id/booking_pay' => 'bookings#pay', as: :booking_pay
    get '/admin_find_rooms' => 'rooms#admin_find', as: :admin_find_rooms
    get '/employee_find_rooms' => 'rooms#employee_find_rooms', as: :employee_find_rooms
    get '/bookings_services_watting' => 'booking_services#waitting', as: :booking_services_waitting
    resources :employees
    post 'users/:id/changepassword' => 'users#changepassword', as: :changepassword
    post 'users/:id/update_avatar' => 'users#update_avatar', as: :update_avatar
    delete 'sessions#logout' => 'sessions#account_logout_out', as: :logout
    put 'booking_services/chooseds/pay' => 'booking_services#pay_chooseds', as: :booking_services_pay_chooseds
    put 'booking_services/invoice' => 'booking_services#invoice', as: :booking_services_invoice
    resources :revenues
  end

    get 'index' => 'homepages#index'
    get '/homepages/event' => 'homepages#event', as: :home_event
    resources :bookings, only: %w[new create show]
    resources :rooms, only: %w[show index]
    resources :customers
    root 'homepages#home'
    get '/booking/verify/success' => 'booking_verifies#success'
    get 'bookings/:id/watting_verify' => 'booking_verifies#watting_verify', as: :booking_watting_verify
    resources :booking_verifies, only: :edit
    post 'create_booking_with_payment' => 'bookings#create_booking_with_payment', as: :create_booking_with_payment
end
