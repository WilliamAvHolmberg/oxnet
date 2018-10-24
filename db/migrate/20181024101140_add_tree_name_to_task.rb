class AddTreeNameToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :treeName, :string
  end
end
