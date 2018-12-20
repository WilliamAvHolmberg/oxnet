json.extract! rs_item, :id, :item_id, :item_name, :created_at, :updated_at
json.url rs_item_url(rs_item, format: :json)
