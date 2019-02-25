class AddMaxSlavesToSchemas < ActiveRecord::Migration[5.2]
  def change
    add_column :schemas, :max_slaves, :integer, :null => false, :default => 10000
  end
end
