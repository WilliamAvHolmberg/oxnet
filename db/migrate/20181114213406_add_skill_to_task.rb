class AddSkillToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :skill, :string
  end
end
