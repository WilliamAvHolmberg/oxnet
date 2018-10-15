class AddColumnExecutedToInstruction < ActiveRecord::Migration[5.2]
  def change
    add_column :instructions, :completed, :boolean, :default => false
  end
end
