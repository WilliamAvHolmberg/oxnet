class AddComputerToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :computer, foreign_key: true
  end
end
