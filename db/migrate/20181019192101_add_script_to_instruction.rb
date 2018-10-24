class AddScriptToInstruction < ActiveRecord::Migration[5.2]
  def change
    add_reference :instructions, :script, foreign_key: true
  end
end
