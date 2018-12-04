class AddColumnToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :created, :boolean, default: true
  end
end
