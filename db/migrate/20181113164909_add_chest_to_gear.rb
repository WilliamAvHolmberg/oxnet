class AddChestToGear < ActiveRecord::Migration[5.2]
  def change
    add_reference :gears, :chest, :class => "RSItem"
  end
end
