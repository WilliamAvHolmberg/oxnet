class CreateMuleLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :mule_logs do |t|
      t.belongs_to :account, foreign_key: true
      t.integer :item_amount
      t.string :mule

      t.timestamps
    end
  end
end
