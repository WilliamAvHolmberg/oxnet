class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :rs_items, :item_name, :item_name
    rename_column :rs_items, :item_id, :item_id
  end
end
