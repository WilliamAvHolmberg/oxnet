class AddInventoryToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :inventory, foreign_key: true
  end
end
