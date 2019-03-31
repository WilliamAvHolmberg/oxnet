class AddFoodColumnToInventoryItem < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_items, :food, :boolean, :default => false
  end
end
