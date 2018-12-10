json.extract! mule_log, :id, :account_id, :item_amount, :mule, :created_at, :updated_at
json.url mule_log_url(mule_log, format: :json)
