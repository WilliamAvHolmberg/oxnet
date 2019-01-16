class AddColumnToProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :last_used, :datetime
  end
end
