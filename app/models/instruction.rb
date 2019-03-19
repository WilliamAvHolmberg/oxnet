class Instruction < ApplicationRecord
  belongs_to :instruction_type
  belongs_to :account, optional: true
  belongs_to :computer, optional: true
  belongs_to :script, optional: true

  def self.get_uncompleted_instructions_10
    now = Time.now.utc
    return Instruction.where(completed: false, created_at: now-10.minutes..now)
  end
  def self.get_uncompleted_instructions_60
    now = Time.now.utc
    return Instruction.where(completed: false, created_at: now-60.minutes..now)
  end

  def time_since_last_log
    last_logged = created_at
    current_time = Time.now.utc
    return ((current_time - last_logged)/60).round(1) # difference in minutes
  end

  def is_relevant
    #if difference is larger than 5 minutes  we can suppose that the account is not logged in
    if (instruction_type.name == "CREATE_ACCOUNT")
      return time_since_last_log < 60
    end
    return time_since_last_log < 10
  end

  def get_time_since_creation
    logs = logs.all
    start_log = nil
    total_time = 0
    if logs != nil
      logs.each_with_index do |current_log, index|
        nextLog = logs.get(index)
        if start_log == nil
          start_log = current_log
        elsif nextLog == nil
          total_time += (current_log.created_at - start_log.created_at)/60
          return total_time
        elsif nextLog.created_at - current_log.created_at/60 > 5
          total_time += (current_log.created_at - start_log.created_at)/60
          start_log = nextLog
        end
      end
    else
      return 0
    end
  end
end
