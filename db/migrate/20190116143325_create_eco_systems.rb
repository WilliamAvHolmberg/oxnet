class CreateEcoSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :eco_systems do |t|
      t.string :name
      t.timestamps
    end
    add_reference :accounts, :eco_system, foreign_key: true
    add_reference :computers, :eco_system, foreign_key: true
    add_reference :proxies, :eco_system, foreign_key: true




  end
end
