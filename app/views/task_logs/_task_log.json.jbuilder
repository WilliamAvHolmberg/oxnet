json.extract! task_log, :id, :money_per_hour, :xp_per_hour, :account_id, :task_id, :respond, :position, :created_at, :updated_at
json.url task_log_url(task_log, format: :json)
