class AddColumnIsMemberToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :member, :boolean, :default => false
  end
end
