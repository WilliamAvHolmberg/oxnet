class AddFoodToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :food, :class => "RSItem"
  end
end
