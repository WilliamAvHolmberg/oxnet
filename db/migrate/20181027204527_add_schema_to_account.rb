class AddSchemaToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :schema, foreign_key: true
  end
end
