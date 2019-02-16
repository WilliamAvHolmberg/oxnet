class AddMoneyMadeToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :money_made, :integer
  end
end
