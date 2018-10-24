class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.belongs_to :bank_area, class_name: "Area"
      t.belongs_to :action_area, class_name: "Area"
      t.belongs_to :task_type, foreign_key: true

      t.timestamps
    end
  end
end
