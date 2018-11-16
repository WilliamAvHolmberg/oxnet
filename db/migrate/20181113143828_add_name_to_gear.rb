class AddNameToGear < ActiveRecord::Migration[5.2]
  def change
    add_column :gears, :name, :string
  end
end
