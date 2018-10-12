class AddComputerToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :computer_id, :integer
  end
end
