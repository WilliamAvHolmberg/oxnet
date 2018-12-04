class CreateQuests < ActiveRecord::Migration[5.2]
  def change
    create_table :quests do |t|
      t.string :name
      t.boolean :completed
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
