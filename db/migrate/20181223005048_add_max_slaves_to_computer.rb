class AddMaxSlavesToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :max_slaves, :integer, :default => 10
  end
end
