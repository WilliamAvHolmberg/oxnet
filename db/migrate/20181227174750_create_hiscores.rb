class CreateHiscores < ActiveRecord::Migration[5.2]
  def change
    create_table :hiscores do |t|
      t.belongs_to :skill, foreign_key: true

      t.timestamps
    end
  end
end
