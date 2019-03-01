class AddAutoAssignToProxies < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :auto_assign, :boolean, default: true
  end
end
