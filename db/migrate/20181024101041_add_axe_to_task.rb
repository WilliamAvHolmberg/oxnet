class AddAxeToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :axe, :class => "RSItem"
  end
end
