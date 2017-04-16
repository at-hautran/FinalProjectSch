Rails.application.routes.draw do
  namespace :cms do
    root 'sessions#new'
    resource :users
    resource :sessions
  end
  root 'homepages#home'
  # get 'homepages/booking', to: 'homepages#booking'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
