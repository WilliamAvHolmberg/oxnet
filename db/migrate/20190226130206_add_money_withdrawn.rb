class AddMoneyWithdrawn < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :money_withdrawn, :integer, :default => 0
  end
end
