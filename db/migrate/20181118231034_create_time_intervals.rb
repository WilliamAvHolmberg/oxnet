class CreateTimeIntervals < ActiveRecord::Migration[5.2]
  def change
    create_table :time_intervals do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.belongs_to :schema, foreign_key: true

      t.timestamps
    end
  end
end
