class CreateRequirements < ActiveRecord::Migration[5.2]
  def change
    create_table :requirements do |t|
      t.belongs_to :skill, foreign_key: true
      t.integer :level
      t.belongs_to :task, foreign_key: true

      t.timestamps
    end
  end
end
