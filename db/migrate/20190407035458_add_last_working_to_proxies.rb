class AddLastWorkingToProxies < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :last_checked, :datetime, :null => false, :default => DateTime.now
    add_column :proxies, :available, :boolean, :null => false, default: true
  end
end
