json.extract! rs_item, :id, :itemId, :itemName, :created_at, :updated_at
json.url rs_item_url(rs_item, format: :json)
