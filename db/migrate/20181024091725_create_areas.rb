class CreateAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|
      t.string :name
      t.text :coordinates

      t.timestamps
    end
  end
end
