class AddItemToInventory < ActiveRecord::Migration[5.2]
  def change
    add_reference :inventory_items, :item, :class => "RSItem"
  end
end
