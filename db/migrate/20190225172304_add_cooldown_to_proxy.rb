class AddCooldownToProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :cooldown, :integer, :default => 0
  end
end
