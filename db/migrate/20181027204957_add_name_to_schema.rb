class AddNameToSchema < ActiveRecord::Migration[5.2]
  def change
    add_column :schemas, :name, :string
  end
end
