class RemoveAccountFromQuest < ActiveRecord::Migration[5.2]
  def change
    remove_column :quests, :account_id
    remove_column :quests, :completed
  end
end
