class AddQuestPointsToQuests < ActiveRecord::Migration[5.2]
  def change
    add_column :quests, :quest_points, :integer, :null => false, :default => 1
  end
end
