class Proxy < ApplicationRecord
  has_many :accounts
  belongs_to :eco_system
  def is_available
    respond = Net::Ping::TCP.new(ip, port).ping
    return respond != nil && respond != false && respond > 0
  end

  def get_active_accounts
    return accounts.where(banned: false, created: true)
  end
end
