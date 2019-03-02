class AddUnlockCooldownToProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :unlock_cooldown, :datetime, :default => DateTime.now
  end
end
