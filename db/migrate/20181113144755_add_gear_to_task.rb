class AddGearToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :gear, foreign_key: true
  end
end
