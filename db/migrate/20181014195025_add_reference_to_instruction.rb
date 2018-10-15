class AddReferenceToInstruction < ActiveRecord::Migration[5.2]
  def change
    add_reference :instructions, :computer, foregin_key: true
  end
end
