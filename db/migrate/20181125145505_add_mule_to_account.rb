class AddMuleToAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :mule, :class_name => "Account"
  end
end
