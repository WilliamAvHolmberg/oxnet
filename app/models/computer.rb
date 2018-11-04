class Computer < ApplicationRecord
  has_many :logs

  def last_log
    return logs.last
  end

  def time_since_last_log
    if last_log == nil
      return 50000000000
    else
      last_logged = last_log.created_at
      current_time = Time.now
      return ((current_time - last_logged)).round # difference in seconds
    end
  end

  def time_since_last_log_nexus
    if last_log == nil
      return 50000000000
    else
      last_logged = last_log.created_at
      current_time = Time.now
      return ((current_time - last_logged)).round # difference in seconds
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
    start_log = nil
    total_time = 0
    logs = self.logs.sort_by &:created_at
    if logs != nil
      logs.each_with_index do |current_log, index|
        nextLog = logs[index+1]
        if start_log == nil
          start_log = current_log
        elsif nextLog == nil
          time = (current_log.created_at - start_log.created_at)
          total_time += time
        elsif (nextLog.created_at - current_log.created_at) > 35
          puts "current time: #{total_time}"
          puts "created at: #{start_log.created_at}"
          puts "this one: #{current_log.created_at}"
          puts "difference: #{current_log.created_at - start_log.created_at}"
          puts "next log: #{nextLog.created_at}"
          time = (current_log.created_at - start_log.created_at)
          total_time += time
          start_log = nextLog
          puts total_time
        end
      end
    else
      return 0
    end
    puts "hello: #{total_time}"
    return total_time
  end
end
