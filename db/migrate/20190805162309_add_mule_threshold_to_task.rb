class AddMuleThresholdToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :mule_threshold, :integer, :default => 50000
  end
end
