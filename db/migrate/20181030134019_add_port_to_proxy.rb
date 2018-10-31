class AddPortToProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :port, :string
  end
end
