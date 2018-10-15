class CreateInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :instructions do |t|
      t.belongs_to :instruction_type, foreign_key: true

      t.timestamps
    end
  end
end
