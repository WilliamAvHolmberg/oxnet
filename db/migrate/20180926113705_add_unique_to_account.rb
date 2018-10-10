class AddUniqueToAccount < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :login, :string, unique: true
  end
end
