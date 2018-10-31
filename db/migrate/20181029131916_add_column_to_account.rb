class AddColumnToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :banned, :boolean, default: false
  end
end
