class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations do |t|
      t.string :name
      t.boolean :use_creation_server
      t.belongs_to :computer, foreign_key: true, :class => "creation_server"
      t.timestamps
    end
  end
end
