class AddColumnAssignedToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :assigned, :boolean, :default => false
  end
end
