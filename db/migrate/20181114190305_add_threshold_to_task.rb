class AddThresholdToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :loot_threshold, :integer
  end
end
