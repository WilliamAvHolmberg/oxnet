class CreateRsItems < ActiveRecord::Migration[5.2]
  def change
    create_table :rs_items do |t|
      t.integer :item_id
      t.string :item_name

      t.timestamps
    end
  end
end
