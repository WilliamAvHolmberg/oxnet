class AddGePriceToRsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :rs_items, :ge_price, :integer, :default => 0
  end
end
