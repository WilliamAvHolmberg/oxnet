json.extract! task, :id, :name, :bank_area_id, :action_area_id, :task_type_id, :created_at, :updated_at
json.url task_url(task, format: :json)
