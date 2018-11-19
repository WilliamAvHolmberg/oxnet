class AddBuyAmountToInventoryItem < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_items, :buy_amount, :integer, default: '1'
  end
end
