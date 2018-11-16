class AddMonsterNameToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :monster_name, :string
  end
end
