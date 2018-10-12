class CreateComputers < ActiveRecord::Migration[5.2]
  def change
    drop_table :computers
    create_table :computers do |t|
      t.string :ip
      t.string :name

      t.timestamps
    end
    add_index :computers, :name, unique: true
  end
end
