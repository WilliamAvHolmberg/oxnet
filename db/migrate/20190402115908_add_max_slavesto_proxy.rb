class AddMaxSlavestoProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :proxies, :max_slaves, :integer, :default => 1

  end
end
