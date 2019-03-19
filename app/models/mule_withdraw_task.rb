class MuleWithdrawTask < ApplicationRecord
  belongs_to :area
  belongs_to :task_type
  belongs_to :account


  def time_since_last_log
    last_logged = created_at
    current_time = Time.now.utc
    return ((current_time - last_logged)/60).round(1) # difference in minutes
  end

  def is_relevant
    #if difference is larger than 5 minutes  we can suppose that the account is not logged in
    if time_since_last_log > 10
      puts "withdraw task is ooold"
      return false
    end
    puts "nowayyy"
    return true;
  end
end
