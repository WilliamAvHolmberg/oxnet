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
  belongs_to :rs_world
  belongs_to :eco_system


  validates_uniqueness_of :login

  def self.all_available_accounts
    return Account.where(banned: false, locked:false, created: true)
  end
  def self.all_accounts_online
    return all_available_accounts.where("last_seen > NOW() - INTERVAL '1 MINUTE'")
  end

  def proxy
    proxy_id = read_attribute(:proxy_id)
    if @last_proxy_id != proxy_id
      @proxy = nil
      @last_proxy_id = proxy_id
    end
    if @proxy == nil
      @proxy = Proxy.where(id: proxy_id).first if proxy_id != nil
      if @proxy == nil
        @proxy = Proxy.all.select{|proxy| proxy.accounts.include? self}.first
        if @proxy == nil
          return Proxy.find_or_initialize_by(ip: " ", port: " ", username: " ", password: " ", location: "none")
        else
          return @proxy
        end
      end
    end
    return @proxy
  end

  def proxy_is_available?()
    if proxy == nil || proxy.ip.length < 5
      return true
    end
    ping = Net::Ping::TCP.new(proxy.ip, proxy.port).ping
    ping.round(2) if !ping.nil?
    return ping
  end

  def time_since_last_log
    if self.last_seen == nil
      return 50000000000
    else
      current_time = Time.now
      return ((current_time - self.last_seen)/60).round # difference in minutes
    end
  end

  def is_connected
    return time_since_last_log < 1
  end

  def is_available
    #if difference is larger than 6 minutes  we can assume that the account is not logged in
    if account_type.name.include?("MULE")
      return true
    else
      return time_since_last_log > 3
    end
  end
  def computer_is_available
    return self.computer_id != nil && self.computer != nil && self.computer.is_available_to_nexus && self.computer.can_connect_more_accounts
  end
  def isAccReadToLaunch
    acc = self
    return if !acc.computer_is_available
    return if !acc.is_available
    return if acc.proxy == nil || !acc.proxy.is_available
    if acc.schema == nil
      puts "No schema for #{acc.username}"
      return false
    end
    if acc.schema.get_suitable_task(acc) == nil
      return false
    end
    return true
  end


  def get_time_online
    return time_online
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

  def get_money_withdrawn(mule_logs)
    money_withdrawn = 0
    mule_logs.select {|log| log.mule.downcase.include? username.downcase}.each do |log|
      money_withdrawn += log.item_amount
    end
    return money_withdrawn
  end

  def get_total_money_deposited
    money_deposited = 0
    mule_logs.select {|log| log.account.username.downcase.include? username.downcase}.each do |log|
      money_deposited += log.item_amount
    end
    return money_deposited
  end

  def get_total_money_withdrawn
    money_withdrawn = 0
    MuleLog.all.select {|log| log.mule.downcase.include? username.downcase}.each do |log|
      money_withdrawn+= log.item_amount
    end
    return money_withdrawn
  end

  def get_money_deposited(mule_logs)
    money_deposited = 0
    mule_logs.select {|log| log.account.username.downcase.include? username.downcase}.each do |log|
      money_deposited += log.item_amount
    end
    return money_deposited
  end

  def get_total_level
    total_level = 0
    if stats != nil && stats.length > 0
     stats.each do |stat|
        if stat.level != nil
          total_level += stat.level
        end
      end
    end
    if account_type != nil && account_type.name.include?("MULE") #MULE
      total_level += 100;
    end
    return total_level
  end


  def self.launch_accounts(secsDelay)
    accounts = Account.includes(:account_type, :computer, :schema).where(banned: false, created: true, locked: false)
    if !accounts.nil? && !accounts.blank?
      accounts = accounts.select{|acc| acc != nil && acc.account_type.name == "SLAVE"}
    end
    if !accounts.nil? && !accounts.blank?
      accounts = accounts.sort_by{|acc|acc.get_total_level}.reverse
      accounts.each do |acc|
        computer = acc.computer if acc.computer_id != nil
        next if computer == nil || !computer.is_available_to_nexus || !computer.can_connect_more_accounts
        next if !acc.isAccReadToLaunch
        Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
        Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
        puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
        sleep(secsDelay.seconds)
      end
    else
      puts "No accounts to launch"
    end
  end

end
