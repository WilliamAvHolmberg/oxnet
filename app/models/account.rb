class Account < ApplicationRecord
  has_one :proxy
  has_many :levels, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :instructions, dependent: :destroy
  belongs_to :schema

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
    return time_since_last_log > 1
  end

  def get_time_online
    start_log = nil
    total_time = 0
    logs = self.logs.sort_by &:created_at
    if logs != nil
      puts logs.length
      logs.each_with_index do |current_log, index|
        puts "loop:#{index}"
        nextLog = logs[index+1]
        if start_log == nil
          start_log = current_log
        elsif nextLog == nil
          time = (current_log.created_at - start_log.created_at)
          puts time
          total_time += time
          return total_time
        elsif (nextLog.created_at - current_log.created_at) > 35
          time = (current_log.created_at - start_log.created_at)
          puts time
          total_time += time
          start_log = nextLog
        end
      end
    else
      return 0
    end
    return total_time
  end


  def shall_do_task
    return schema.get_suitable_task != nil
  end

end
