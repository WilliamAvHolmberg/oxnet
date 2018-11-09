class CreateMuleWithdrawTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :mule_withdraw_tasks do |t|
      t.string :name
      t.belongs_to :area, foreign_key: true
      t.belongs_to :task_type, foreign_key: true
      t.string :slave_name
      t.string :item_id
      t.string :item_amount
      t.string :world
      t.boolean :executed
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
