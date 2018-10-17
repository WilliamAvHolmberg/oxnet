Rails.application.routes.draw do
  resources :instructions do
    collection do
      get 'get_accounts', to: "instructions#get_accounts"
    end
  end
  resources :instruction_types
  resources :computers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :accounts
  resources :proxies
  resources :logs
end
