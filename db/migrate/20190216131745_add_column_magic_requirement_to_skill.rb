class AddColumnMagicRequirementToSkill < ActiveRecord::Migration[5.2]
  def change
    add_column :rs_items, :magic_requirement, :integer, :default => 99
  end
end
