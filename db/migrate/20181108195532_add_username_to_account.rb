class AddUsernameToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :username, :string
  end
end
