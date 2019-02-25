class AddEnabledToSchemas < ActiveRecord::Migration[5.2]
  def change
    add_column :schemas, :disabled, :boolean, :null => false, :default => false
  end
end
