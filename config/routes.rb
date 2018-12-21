Rails.application.routes.draw do

  resources :mule_logs
  resources :quest_stats
  resources :stats
  resources :requirements
  resources :skills
  get 'nexus', action: :show, controller: 'nexus'
  post 'create_accounts', action: :create_accounts, controller: 'nexus'
  resources :quests
  resources :lives
  resources :task_logs
  resources :time_intervals
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
  resources :schemas do
    member do
      get 'copy'
      get 'remove_task'
      get 'move_up_task'
      get 'move_down_task'
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
  resources :accounts do
    member do
      get 'json'
    end
  end
  resources :proxies
  resources :logs
end
