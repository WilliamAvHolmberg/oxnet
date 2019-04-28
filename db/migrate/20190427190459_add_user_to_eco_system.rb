class AddUserToEcoSystem < ActiveRecord::Migration[5.2]
  def change
    add_reference :eco_systems, :user, foreign_key: true
  end
end
