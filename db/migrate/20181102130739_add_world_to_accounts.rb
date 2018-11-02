class AddWorldToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :world, :string, :default => "439"
  end
end
