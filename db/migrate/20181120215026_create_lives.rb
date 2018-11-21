class CreateLives < ActiveRecord::Migration[5.2]
  def change
    create_table :lives do |t|

      t.timestamps
    end
  end
end
