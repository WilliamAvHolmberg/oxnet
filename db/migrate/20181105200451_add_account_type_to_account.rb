class AddAccountTypeToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :account_type, foreign_key: true
  end
end
