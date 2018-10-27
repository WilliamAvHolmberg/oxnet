class CreateSchemas < ActiveRecord::Migration[5.2]
  def change
    create_table :schemas do |t|

      t.timestamps
    end
  end
end
