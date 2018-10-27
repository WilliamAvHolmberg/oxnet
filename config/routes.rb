Rails.application.routes.draw do
  resources :schemas
  resources :break_conditions
  resources :rs_items
  resources :tasks
  resources :areas
  resources :task_types
  resources :scripts
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
