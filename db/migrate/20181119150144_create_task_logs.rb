class CreateTaskLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :task_logs do |t|
      t.string :money_per_hour
      t.string :xp_per_hour
      t.belongs_to :account, foreign_key: true
      t.belongs_to :task, foreign_key: true
      t.text :respond
      t.string :position

      t.timestamps
    end
  end
end
