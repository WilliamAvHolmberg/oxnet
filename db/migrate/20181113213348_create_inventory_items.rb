class CreateInventoryItems < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_items do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
