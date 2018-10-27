class AddSchemaToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :schema, foreign_key: true
  end
end
