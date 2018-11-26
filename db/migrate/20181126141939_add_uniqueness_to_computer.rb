class AddUniquenessToComputer < ActiveRecord::Migration[5.2]
  def change
    change_column :computers, :name, :string, unique: true
  end
end
