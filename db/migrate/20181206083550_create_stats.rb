class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
      t.belongs_to :skill, foreign_key: true
      t.integer :level
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
