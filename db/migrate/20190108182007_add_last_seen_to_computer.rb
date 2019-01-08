class AddLastSeenToComputer < ActiveRecord::Migration[5.2]
  def change
    add_column :computers, :last_seen, :datetime, default: Time.now
    add_column :computers, :time_online, :integer, default: 0
  end
end
