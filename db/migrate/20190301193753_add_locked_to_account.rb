class AddLockedToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :locked, :boolean, default: false
  end
end
