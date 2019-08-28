class AddUseGearToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :use_gear, :boolean, :default => false
  end
end
