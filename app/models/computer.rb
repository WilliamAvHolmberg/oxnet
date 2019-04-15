class Computer < ApplicationRecord
  validates_uniqueness_of :name
  has_many :logs
  has_many :accounts
  belongs_to :eco_system



  def time_since_last_log
    if last_seen == nil
      return 50000000000
   else
      current_time = Time.now
      return ((current_time - last_seen)).round(1) # difference in seconds
    end
  end

  def time_since_last_log_nexus
    if last_seen == nil
      return 50000000000
    else
      current_time = Time.now
      return ((current_time - last_seen)).round(1) # difference in seconds
    end
  end


  def is_available_to_nexus
    return time_since_last_log_nexus < 30
  end

  def is_connected
    #if difference is larger than 30 seconds we can suppose that the computer is still connected to nexus
    return time_since_last_log < 30
  end

  def get_time_online
    return time_online
  end
  def get_available_accounts
    accounts = Account.where(computer: self, banned: false, locked:false, created: true)
    return accounts
  end
  def get_connected_accounts
    accounts = get_available_accounts.select{|acc| acc.is_connected}
    return accounts
  end

  @lastGotConnected = 0
  @lastConnected = 0
  def get_connected_accounts_count
    @lastGotConnected = Time.now - 100.hours if @lastGotConnected == nil
    return @lastConnected if Time.now - @lastGotConnected < 5.seconds # Caching
    @lastGotConnected = Time.now

    min_ago = Time.now.utc - 1.minutes
    @lastConnected = Account.where(computer_id: self.id, banned: false, locked:false, created: true, last_seen: min_ago..Time.now.utc).count
    return @lastConnected
  end

  def can_connect_more_accounts
    return max_slaves > get_connected_accounts_count
  end
end
