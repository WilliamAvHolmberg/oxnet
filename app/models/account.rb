class Account < ApplicationRecord
  has_one :proxy
  has_many :logs
  validates_uniqueness_of :login

  def last_log
    return logs.last
  end

  def time_since_last_log
    if last_log == nil
      return 50000000000
    else
      last_logged = last_log.created_at
      current_time = Time.now
      return ((current_time - last_logged)/60).round # difference in minutes
    end
  end

  def is_available
    #if difference is larger than 5 minutes  we can suppose that the account is not logged in
    return time_since_last_log > 5
  end

end
