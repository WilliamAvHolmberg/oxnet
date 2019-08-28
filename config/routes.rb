Rails.application.routes.draw do

  devise_for :users
  devise_for :eco_systems

  scope '/api' do
    scope '/dashboard' do
      get '/', action: :dashboard, controller: 'nexus'
    end
  end
  scope '/antiban' do
    scope '/mule_connections' do
      get '/', action: :view, controller: 'nexus'
    end
  end
  root :to => redirect('/nexus')
  resources :eco_systems
  resources :hiscores do
    collection do
      get 'time_online'
    end
    member do
      get 'show_all'
    end
  end
  resources :rs_worlds
  resources :mule_logs
  resources :quest_stats
  resources :stats
  resources :requirements
  resources :skills

  resources :nexus do
    member do
      get 'dashboard' => 'nexus/dashboard'
    end
    collection do
      get 'update_mule_logs'
    end
  end
  # get 'nexus', action: :show, controller: 'nexus'
  get 'charts', action: :show, controller: 'charts'
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
      get 'ban'
      get 'disconnect'
    end
    collection do
      get 'available_mail_domains'
    end
    collection do
      get 'get_player_positions'
    end
  end
  resources :proxies do
    member do
      get 'json'
    end
    collection do
      get 'import'
      post 'import', action: :import, controller: 'proxies'
    end
  end
  resources :logs
end
