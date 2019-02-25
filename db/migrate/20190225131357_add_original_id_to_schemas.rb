class AddOriginalIdToSchemas < ActiveRecord::Migration[5.2]
  def change
    add_column :schemas, :original_id, :bigint
  end
end
