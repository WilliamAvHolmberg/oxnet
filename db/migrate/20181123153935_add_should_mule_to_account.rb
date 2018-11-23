class AddShouldMuleToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :should_mule, :boolean, :default => false
  end
end
