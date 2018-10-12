Rails.application.routes.draw do
  resources :computers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :accounts
  resources :proxies
  resources :logs
end
