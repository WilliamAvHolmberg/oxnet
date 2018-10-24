class CreateRsItems < ActiveRecord::Migration[5.2]
  def change
    create_table :rs_items do |t|
      t.integer :itemId
      t.string :itemName

      t.timestamps
    end
  end
end
