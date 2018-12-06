class ChangeColumnInTask < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :skill
  end
end
