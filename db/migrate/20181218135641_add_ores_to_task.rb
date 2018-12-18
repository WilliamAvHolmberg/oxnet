class AddOresToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :ores, :string
  end
end
