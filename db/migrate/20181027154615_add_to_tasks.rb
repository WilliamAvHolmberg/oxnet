class AddToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :break_condition, foreign_key: true
    add_column :tasks, :break_after, :integer
  end
end
