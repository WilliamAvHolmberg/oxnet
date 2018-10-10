class AddLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :text
      t.belongs_to :account, index: true;
      t.timestamps
    end
  end
end
