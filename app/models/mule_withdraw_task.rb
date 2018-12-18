class MuleWithdrawTask < ApplicationRecord
  belongs_to :area
  belongs_to :task_type
  belongs_to :account


  def time_since_last_log
    last_logged = created_at
    current_time = Time.now
    return ((current_time - last_logged)/60).round # difference in minutes
  end

  def is_relevant
    #if difference is larger than 5 minutes  we can suppose that the account is not logged in
    puts "nowayyy"
    return time_since_last_log < 10
  end
end
