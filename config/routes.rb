Rails.application.routes.draw do
  namespace :cms do
    resource :sessions
    resource :users
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
