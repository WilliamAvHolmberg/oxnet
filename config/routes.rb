Rails.application.routes.draw do
  resources :inventories do
    member do
      get 'copy'
    end
  end
  resources :inventory_items
  resources :gears do
    member do
      get 'copy'
    end
  end
  resources :mule_withdraw_tasks
  resources :account_types
  resources :levels
  resources :schemas do
    member do
      get 'copy'
      get 'remove_task'
    end
  end
  resources :break_conditions
  resources :rs_items
  resources :tasks do
    member do
      get 'copy'
    end
  end
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
