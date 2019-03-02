require_relative '../functions'
class Proxy < ApplicationRecord
  has_many :accounts
  belongs_to :eco_system

  def is_available

    return Pinger.ProxyAvailable(ip, port)
  end

  def has_cooldown
    end_time = DateTime.now
    start_time = last_used
    elapsed_time = (end_time.to_f - start_time.to_f).to_i
    has_cooldown = elapsed_time < cooldown + custom_cooldown
    if !has_cooldown
      self.update_attributes(cooldown: 0)
    end
    return has_cooldown
  end

  def is_ready_for_unlock
    return DateTime.now > unlock_cooldown
  end
  def cooldown
    num = (last_used.to_f + self[:cooldown] + custom_cooldown - DateTime.now.to_f).to_i
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
