class AddLastSeenToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :last_seen, :datetime
    add_column :accounts, :time_online, :integer
  end
end
