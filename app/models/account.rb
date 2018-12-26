class Account < ApplicationRecord
  has_many :quest_stats, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :instructions, dependent: :destroy
  has_many :mule_withdraw_tasks, dependent: :destroy
  has_many :task_logs, dependent: :destroy
  has_many :mule_logs, dependent: :destroy
  has_many :stats
  belongs_to :schema
  belongs_to :account_type
  belongs_to :computer
  has_many :slaves, :class_name => "Account"
  belongs_to :mule, :class_name => "Account", foreign_key: "mule_id", optional: true
  belongs_to :proxy


  validates_uniqueness_of :login

  def last_log
    return logs.last
  end

  def proxy
    proxy = Proxy.all.select{|proxy| proxy.accounts.include? self}.first
    if proxy == nil
      return Proxy.find_or_initialize_by(ip: " ", port: " ", username: " ", password: " ", location: "none")
    else
      return proxy
    end
  end

  def proxy_is_available?()
    if proxy == nil || proxy.ip.length < 5
      return true
    end
    return Net::Ping::TCP.new(proxy.ip, proxy.port).ping
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

  def is_connected
    return time_since_last_log < 1
  end

  def is_available
    #if difference is larger than 6 minutes  we can assume that the account is not logged in
    if account_type.name == "MULE"
      return true
    else
    return time_since_last_log > 3
    end
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
          return total_time
        elsif (nextLog.created_at - current_log.created_at) > 35
          time = (current_log.created_at - start_log.created_at)
          total_time += time
          start_log = nextLog
        end
      end
    else
      return 0
    end
    return total_time
  end

  def get_average_money
    if task_logs != nil && task_logs.all.length > 0
      amount_of_logs = task_logs.all.length
      total_amount_of_money = 0
      task_logs.all.each do |log|
        if log.money_per_hour != nil
        total_amount_of_money += log.money_per_hour.to_i
        else
          amount_of_logs -=1
        end
      end
      return total_amount_of_money/amount_of_logs
    end
    return 0
  end


  def shall_do_task
    return !banned && created && schema.get_suitable_task(self) != nil
  end

end
