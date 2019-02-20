require_relative '../functions'
class Proxy < ApplicationRecord
  has_many :accounts
  belongs_to :eco_system

  def is_available
    return Pinger.ProxyAvailable(ip, port);
  end

  def get_active_accounts
    return accounts.where(banned: false, created: true)
  end
end
