class AddColumnToRsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :rs_items, :defence_requirement, :integer, :default => 99
    add_column :rs_items, :attack_requirement, :integer, :default => 99
    add_column :rs_items, :strength_requirement, :integer, :default => 99
    add_column :rs_items, :range_requirement, :integer, :default => 99
  end
end
