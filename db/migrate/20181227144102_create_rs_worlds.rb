class CreateRsWorlds < ActiveRecord::Migration[5.2]
  def change
    create_table :rs_worlds do |t|
      t.integer :number
      t.boolean :members_only

      t.timestamps
    end
    add_reference :accounts, :rs_world, foreign_key: true
  end
end
