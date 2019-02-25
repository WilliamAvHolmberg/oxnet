require_relative '../functions'
class Proxy < ApplicationRecord
  has_many :accounts
  belongs_to :eco_system

  def is_available
    end_time = DateTime.now
    start_time = last_used
    elapsed_time = (end_time.to_f - start_time.to_f).to_i
    default_cooldown = 60
    has_cooldown = elapsed_time < cooldown + default_cooldown
    if !has_cooldown
      self.update_attributes(cooldown: 0)
    end
    return Pinger.ProxyAvailable(ip, port) && !has_cooldown
  end

  def cooldown
    num = DateTime.now.to_f + self[:cooldown] - DateTime.now
    if num < 0
      self.update_attributes(cooldown: 0)
      num = 0
    end
    return num
  end
  def get_active_accounts
    return accounts.where(banned: false, created: true)
  end
end
