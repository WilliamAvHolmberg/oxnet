class AddCreatedAtIndexes < ActiveRecord::Migration[5.2]
  def change
    # add_reference :mule_logs, :created_at, index: true
    # add_reference :task_logs, :created_at, index: true
    # add_reference :logs, :created_at, index: true
    #add_reference :accounts, :last_seen, index: true
    #remove_index :task_logs, [:created_at]
    add_index :task_logs, [:created_at]
    add_index :mule_logs, [:created_at]
    add_index :logs, [:created_at]
    add_index :accounts, [:created_at]
    add_index :mule_withdraw_tasks, [:created_at]
    add_index :instructions, [:created_at]
  end
end
