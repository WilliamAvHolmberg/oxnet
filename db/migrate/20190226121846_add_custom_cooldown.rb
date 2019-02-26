class AddCustomCooldown < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :custom_cooldown, :integer, :default => 120
  end
end
