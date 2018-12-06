class CreateQuestStats < ActiveRecord::Migration[5.2]
  def change
    create_table :quest_stats do |t|
      t.belongs_to :quest, foreign_key: true
      t.boolean :completed
      t.belongs_to :account, foreign_key: true

      t.timestamps
    end
  end
end
