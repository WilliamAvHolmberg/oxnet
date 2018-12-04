class AddColumnsToRsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :rs_items, :members, :boolean
    add_column :rs_items, :stackable, :boolean
    add_column :rs_items, :equipment_slot, :string
    add_column :rs_items, :weapon_type, :string
    add_column :rs_items, :interface_options, :string
    add_column :rs_items, :tradeable, :boolean
    add_column :rs_items, :exchange, :string
  end
end
