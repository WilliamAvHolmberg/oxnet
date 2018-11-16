class AddInventoryToInventoryItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :inventory_items, :inventory, foreign_key: true
  end
end
