class AddBooleanToSchema < ActiveRecord::Migration[5.2]
  def change
    add_column :schemas, :default, :boolean, default: true
  end
end
