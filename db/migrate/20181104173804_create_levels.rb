class CreateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :levels do |t|
      t.string :name
      t.string :level
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
