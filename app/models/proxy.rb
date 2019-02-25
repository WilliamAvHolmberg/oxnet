require_relative '../functions'
class Proxy < ApplicationRecord
  has_many :accounts
  belongs_to :eco_system

  def is_available
    end_time = DateTime.now
    start_time = last_used
    elapsed_time = (end_time.to_f - start_time.to_f).to_i
    return Pinger.ProxyAvailable(ip, port) && elapsed_time > 120
  end

  def get_active_accounts
    return accounts.where(banned: false, created: true)
  end
end
