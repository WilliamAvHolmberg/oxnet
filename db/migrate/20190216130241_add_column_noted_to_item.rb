class AddColumnNotedToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :rs_items, :noted, :boolean
  end
end
