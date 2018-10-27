class CreateBreakConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :break_conditions do |t|
      t.string :name

      t.timestamps
    end
  end
end
