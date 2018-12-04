class AddQuestToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :quest, foreign_key: true
  end
end
