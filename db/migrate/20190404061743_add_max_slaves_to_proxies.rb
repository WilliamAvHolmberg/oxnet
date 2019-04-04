class AddMaxSlavesToProxies < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :max_slaves, :integer, :null => false, :default => 1000
  end
end
