require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require 'net/ping'
require 'acts_as_list'
require_relative 'generate_account'


@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

def find_suitable_account
  return Account.where(banned: false, created: true).select{|a| a.is_available}.first
end

def computer_get_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    puts "ACC: #{ins.account}"

    if ins.account != nil


    if ins.instruction_type.name == "CREATE_ACCOUNT"
      account = ins.account
      log = Log.new(account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out for the first time to: #{ins.computer.name}")
      log.save
      res =  "create_account:#{account.username}:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + account.world.chomp + ":NEX" + ":http://oxnetserver.ddns.net:3000/accounts/#{account.id}/json"
      ins.update(:completed => true)
      ins.save
      return res
    elsif ins.instruction_type.name == "NEW_CLIENT" && ins.account_id == nil
      ins.update(:completed => true)
      puts "wrong"
    return "account_request:0"
    elsif ins.instruction_type.name == "NEW_CLIENT" && ins.account_id != nil
      ins.update(:completed => true)
      ins.save
      account = ins.account
      puts "we got the account"
      #res =  "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + world.chomp + ":NEX"
      res =  "account_request:1:" + "http://oxnetserver.ddns.net:3000/accounts/#{account.id}/json"
      puts "we got the address"
      if ins.computer != nil
        log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      else
        log = Log.new(account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      end
      log.save
      return res
    end
    end
    puts "handed out"
    return "logged:f"
  end
end

def account_get_instruction_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    if ins.instruction_type.name == "DISCONNECT"
      puts "dis"
      res =  "DISCONNECT:1:"
      log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} shall disconnect")
      log.save
      ins.update(:completed => true)
      return res
    else
      return "logged:fine"
    end
    return "logged:f"
  end
end


def get_mule_withdraw_task_respond(account)
  mule_withdraw_tasks = MuleWithdrawTask.where(:account => account,:created_at => (Time.now - 20.minutes..Time.now)).select{|task| !task.executed && task.is_relevant && !task.account!= nil && task.account.id == account.id }
  if mule_withdraw_tasks != nil && mule_withdraw_tasks.length > 0
    task = mule_withdraw_tasks[0]
  else
    puts "dc player"
    return "DISCONNECT:1"
  end

  task_type = task.task_type
  item_id = task.item_id
  item_amount = task.item_amount
  world = task.world
  slave_name = task.slave_name


  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  res = "task_respond:1:#{task_type.name}:#{slave_name}:#{world.chomp}:#{item_id.chomp}:#{item_amount.chomp}"
  task.update(:executed => true)
  task.save
  puts res
  return res
end

def get_task_respond(task, account)
  case task.task_type.name
  when "AGILITY"
    puts "agil respond"
    return get_agility_task_respond(task, account)
  when "WOODCUTTING"
    puts " res wc respond"
    return get_woodcutting_task_respond(task, account)
    #other cases, such as combat, druids.. etc
  when "MINING"
    puts " res mining respond"
    return get_mining_task_respond(task, account)
  when "MULE_WITHDRAW"
  when "MULE_DEPOSIT"
    puts "res mule respond"
    return get_mule_withdraw_task_respond(account)
  when "COMBAT"
    puts "combat res"
    return get_combat_task_respond(task,account)
  when "QUEST"
    puts "quest ress"
    return get_quest_task_respond(task, account)
  end
end

def get_quest_task_respond(task, account)
  puts "get agility respond"
  task_type = task.task_type.name


  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{task.quest.name}"
  return res
end

def account_get_direct_respond(message, account)
  if message == nil
    return "logged:fine"
  else

    puts "Task request"
    if account.account_type != nil && account.account_type.name == "MULE"
      puts "mule"
      return get_mule_withdraw_task_respond(account)
    else if message == "task_request"
      puts "before getting task"
      task = account.schema.get_suitable_task(account)
      puts "after getting task"
      if task == nil
        task_id = 0
        #task = get when next task starts
        #res = "TASK_RESPOND:1:BREAK:#{task_id}:TIME:#{account.schema.get_time_unil_next_task}"
        res = "DISCONNECT:1"
        return res
      else
        puts "found task"
        return get_task_respond(task, account)
      end
    else
      return "logged:fine"
    end
    return "logged:f"
    end
    end
end

def update_woodcutting_task(task, account)
  level = account.stats.find_by(skill: Skill.find_by(name: "Woodcutting"))
  puts "updating taskz"
  if level != nil && level.level.to_i > 0
    if level.level.to_i < 21
      puts "bronze axe"
      axe = RsItem.where(item_name: "Bronze axe", stackable: false).first
    elsif level.level.to_i < 41
      puts "rune axe"
      axe = RsItem.where(item_name: "Mithril axe", stackable: false).first
    elsif level.level.to_i < 99
      puts "rune axe"
      axe = RsItem.where(item_name: "Rune axe", stackable: false).first
    end
  end
  task.axe = axe
  task.save
  puts "updated task"
end


def get_agility_task_respond(task, account)
  puts "get agility respond"
  task_type = task.task_type.name

  break_condition = task.break_condition.name
  puts "breakcondition::::: #{break_condition}"
  if task.inventory != nil then inventory = task.inventory.get_parsed_message else inventory ="none" end

  task_duration = "99"
  if break_condition == "TIME"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = "99"
  elsif break_condition == "LEVEL" && task.break_after != nil
    task_duration = "999999"
    level_goal = task.break_after
  elsif break_condition == "TIME_OR_LEVEL"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = task.break_after
    puts task_duration
  end
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{break_condition}:#{task_duration}:#{inventory}:#{level_goal}"
  return res
end

def get_combat_task_respond(task, account)
  puts "get combat respond"
  task_type = task.task_type.name
  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  action_area = task.action_area.coordinates
  monster_name = task.monster_name
  if task.gear.head != nil then head = task.gear.head.formated_name else head = "none" end
  if task.gear.cape != nil then cape = task.gear.cape.formated_name else cape = "none" end
  if task.gear.neck != nil then neck = task.gear.neck.formated_name else neck = "none" end
  if task.gear.weapon != nil then weapon = task.gear.weapon.formated_name else weapon = "none" end
  if task.gear.chest != nil then chest = task.gear.chest.formated_name else chest = "none" end
  if task.gear.shield != nil then shield = task.gear.shield.formated_name else shield = "none" end
  if task.gear.legs != nil then legs = task.gear.legs.formated_name else legs = "none" end
  if task.gear.hands != nil then hands = task.gear.hands.formated_name else hands = "none" end
  if task.gear.feet != nil then feet = task.gear.feet.formated_name else feet = "none" end
  if task.gear.ring != nil then ring = task.gear.ring.formated_name else ring = "none" end
  if task.gear.ammunition != nil then ammunition = task.gear.ammunition.formated_name else ammunition = "none" end
  if task.gear.ammunition_amount != nil then ammunition_amount= task.gear.ammunition_amount else "none" end
  if task.inventory != nil then inventory = task.inventory.get_parsed_message else inventory ="none" end

  break_condition = task.break_condition.name
  puts "breakcondition::::: #{break_condition}"
  task_duration = "99"
  if break_condition == "TIME"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = "99"
  elsif break_condition == "LEVEL" && task.break_after != nil
    task_duration = "999999"
    level_goal = task.break_after
  elsif break_condition == "TIME_OR_LEVEL"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = task.break_after
    puts task_duration
  end
  if task.food != nil then food = task.food.formated_name else food = "none" end
  if task.loot_threshold != nil then loot_threshold = task.loot_threshold else loot_threshold = 100 end
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{monster_name}:#{break_condition}:#{task_duration}:#{head}:#{cape}:#{neck}:#{weapon}:#{chest}:#{shield}:#{legs}:#{hands}:#{feet}:#{ring}:#{ammunition}:#{ammunition_amount}:#{food}:#{inventory}:#{loot_threshold}:#{task.skill.name}:#{level_goal}:#{account.should_mule}"
  return res
end

def update_mining_task(task, account)
  level = account.stats.find_by(skill: Skill.find_by(name: "Mining"))
  puts "updating taskz"
  if level != nil && level.level.to_i > 0
    if level.level.to_i < 21
      puts "bronze axe"
      axe = RsItem.where(item_name: "Bronze pickaxe", stackable: false).first
    elsif level.level.to_i < 41
      puts "rune axe"
      axe = RsItem.where(item_name: "Mithril pickaxe", stackable: false).first
    elsif level.level.to_i < 99
      puts "rune axe"
      axe = RsItem.where(item_name: "Rune pickaxe", stackable: false).first
    end
  end
  task.axe = axe
  task.save
  puts "updated task"
end
def get_mining_task_respond(task, account)
  task_type = task.task_type.name
  update_mining_task(task, account)
  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  action_area = task.action_area.coordinates
  axeID = task.axe.item_id
  axe_name = task.axe.item_name
  ores = task.ores
  break_condition = task.break_condition.name
  if break_condition == "TIME"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = "99"
  elsif break_condition == "LEVEL" && task.break_after != nil
    task_duration = "999999"
    level_goal = task.break_after
  elsif break_condition == "TIME_OR_LEVEL"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = task.break_after
    puts task_duration
  end
  if task.gear.head != nil then head = task.gear.head.formated_name else head = "none" end
  if task.gear.cape != nil then cape = task.gear.cape.formated_name else cape = "none" end
  if task.gear.neck != nil then neck = task.gear.neck.formated_name else neck = "none" end
  if task.gear.weapon != nil then weapon = task.gear.weapon.formated_name else weapon = "none" end
  if task.gear.chest != nil then chest = task.gear.chest.formated_name else chest = "none" end
  if task.gear.shield != nil then shield = task.gear.shield.formated_name else shield = "none" end
  if task.gear.legs != nil then legs = task.gear.legs.formated_name else legs = "none" end
  if task.gear.hands != nil then hands = task.gear.hands.formated_name else hands = "none" end
  if task.gear.feet != nil then feet = task.gear.feet.formated_name else feet = "none" end
  if task.gear.ring != nil then ring = task.gear.ring.formated_name else ring = "none" end
  if task.gear.ammunition != nil then ammunition = task.gear.ammunition.formated_name else ammunition = "none" end
  if task.gear.ammunition_amount != nil then ammunition_amount= task.gear.ammunition_amount else "none" end
  if task.inventory != nil then inventory = task.inventory.get_parsed_message else inventory ="none" end
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{axeID}:#{axe_name}:#{ores}:#{break_condition}:#{task_duration}:#{level_goal}:#{head}:#{cape}:#{neck}:#{weapon}:#{chest}:#{shield}:#{legs}:#{hands}:#{feet}:#{ring}:#{ammunition}:#{ammunition_amount}"
  return res
end
def get_woodcutting_task_respond(task, account)
  task_type = task.task_type.name
  update_woodcutting_task(task, account)
  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  action_area = task.action_area.coordinates
  axeID = task.axe.item_id
  axe_name = task.axe.item_name
  tree_name = task.treeName
  break_condition = task.break_condition.name
  if break_condition == "TIME"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = "99"
  elsif break_condition == "LEVEL" && task.break_after != nil
    task_duration = "999999"
    level_goal = task.break_after
  elsif break_condition == "TIME_OR_LEVEL"
    task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
    level_goal = task.break_after
    puts task_duration
  end
  if task.gear.head != nil then head = task.gear.head.formated_name else head = "none" end
  if task.gear.cape != nil then cape = task.gear.cape.formated_name else cape = "none" end
  if task.gear.neck != nil then neck = task.gear.neck.formated_name else neck = "none" end
  if task.gear.weapon != nil then weapon = task.gear.weapon.formated_name else weapon = "none" end
  if task.gear.chest != nil then chest = task.gear.chest.formated_name else chest = "none" end
  if task.gear.shield != nil then shield = task.gear.shield.formated_name else shield = "none" end
  if task.gear.legs != nil then legs = task.gear.legs.formated_name else legs = "none" end
  if task.gear.hands != nil then hands = task.gear.hands.formated_name else hands = "none" end
  if task.gear.feet != nil then feet = task.gear.feet.formated_name else feet = "none" end
  if task.gear.ring != nil then ring = task.gear.ring.formated_name else ring = "none" end
  if task.gear.ammunition != nil then ammunition = task.gear.ammunition.formated_name else ammunition = "none" end
  if task.gear.ammunition_amount != nil then ammunition_amount= task.gear.ammunition_amount else "none" end
  if task.inventory != nil then inventory = task.inventory.get_parsed_message else inventory ="none" end
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{axeID}:#{axe_name}:#{tree_name}:#{break_condition}:#{task_duration}:#{level_goal}:#{head}:#{cape}:#{neck}:#{weapon}:#{chest}:#{shield}:#{legs}:#{hands}:#{feet}:#{ring}:#{ammunition}:#{ammunition_amount}"
  return res
end



def computer_thread(client, computer)
  puts "started Thread for:#{computer.name} at ip:#{computer.ip}"
  puts " my computer id: #{computer.id}"
  begin
  while(!client.closed?)
    respond = client.gets.split(":")
    #puts respond.length
    if respond[0] == "account_request"
      account = find_suitable_account
      if account == nil
        puts "no account available"
        client.puts "account_request:0"
      else
        world = "424"
        client.puts "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip + ":" + account.proxy.port + ":" + account.proxy.username + ":" + account.proxy.password + ":" + world + ":" + script
        log = Log.new(computer_id: computer.id, account_id: account.id, text: "Account:#{account.login} Handed out to: #{computer.name}")
        log.save
      end
    elsif respond[0] == "log"
      #get new instructions
      instruction_queue = Instruction.where(completed: false).select{|ins| ins.computer_id == computer.id && !ins.completed && ins.is_relevant}
      #puts "Log from: #{computer.name}:::log:#{respond}"
      log = Log.new(computer_id: computer.id, text: respond)
      log.save
      client.puts computer_get_respond(instruction_queue)
      #puts "sent"
    else
      client.puts "ok"
    end
    #puts respond
  end
  rescue
    puts "Computer Thread for: #{client} has been closed"
  end
end

def updateAccountLevels(string, account)
  string.slice! "skills;"
  array = string.split(';')
  array.each do |parsed|
    intern_parse = parsed.split(',')
    puts parsed
    name = intern_parse[0]
    level = intern_parse[1]
    puts name
    puts level
    account_level = Stat.find_or_initialize_by(account_id: account.id, skill: Skill.find_by(name: name))
    account_level.update(level: level)
    account_level.save
  end
end

def updateAccountQuests(string, account)
  string.slice! "quests;"
  array = string.split(';')
  array.each do |parsed|
    intern_parse = parsed.split(',')
    puts parsed
    name = intern_parse[0]
    completed = intern_parse[1]
    puts name
    puts completed
    puts name == nil
    if completed != nil && name != nil
      puts "in here"
    account_quest = QuestStat.find_or_initialize_by(account_id: account.id, quest: Quest.find_by(name: name))
      if completed.include? "true"
        account_quest.update(:completed => true)
      else
        account_quest.update(:completed => false)
      end
    account_quest.save
    end
    end
end

def get_mule_respond(respond, account)
  mule = Account.where(banned: false, created: true).select{|acc| acc.computer.is_connected && acc.is_available && acc.account_type.name == "MULE" && (acc.proxy_is_available? || acc.proxy.ip.length < 5)}
  #if mule != nil && !mule.banned && (mule.proxy_is_available? || mule.proxy.ip.length < 5)
  if mule != nil && mule.length > 0
    mule = mule.sample
    puts "we found mule"
    #create new isntruction for mulec
    computer = mule.computer
    if computer != nil && computer.is_available_to_nexus
      puts "we found computer"
      if !mule.is_connected
        ins = Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => mule.id, :script_id => Script.first.id)
        ins.save
      end
      puts "created instruction"
      #new mule task
      item_id = respond[1]
      item_amount = respond[2]
      trade_name = respond[3]
      world = respond[4]
      mule_type = respond[5]
      puts "MULE_tyPE:#{mule_type}"
      puts world
      mule.update(:world => world)
      mule.save
      task = nil
      if mule_type.include?("deposit")
        task = MuleWithdrawTask.new(:name => "Mule deposit from :#{trade_name}", :task_type => TaskType.find_or_create_by(:name => "MULE_DEPOSIT"),  :account => mule, :item_id => item_id,
                                    :item_amount => item_amount, :slave_name => trade_name, :world => world, :area => Area.find_by(:name => "GRAND_EXCHANGE"))
        puts "mule deposit"
        task.save
      elsif mule_type.include?("withdraw")
        puts "mule_withdraw"
        task = MuleWithdrawTask.new(:name => "Mule withdraw to :#{trade_name}", :task_type => TaskType.find_or_create_by(:name => "MULE_WITHDRAW"),  :account => mule, :item_id => item_id,
                                    :item_amount => item_amount, :slave_name => trade_name, :world => world, :area => Area.find_by(:name => "GRAND_EXCHANGE"))
        task.save
      end
      puts "task created"
      if task != nil
        puts "task not nil"
      end
      #task.update(:executed => false)
      puts "task updated"
      puts "lets send mess back"
      Log.new(computer_id: nil, account_id: mule.id, text: "new mule request from slave:#{trade_name} to #{mule}").save
      return "SUCCESSFUL_MULE_REQUEST:#{mule.username.chomp}:#{mule.world}:#{mule_type}"
    else
      puts "we found no computer"
    end
  else
    puts "we found no mule"
  end
  return "MULE_BUSY"
end

def task_log(account, parsed_respond)
  task_id = parsed_respond[2]
  position = parsed_respond[3]
  xp = parsed_respond[4].split(";")[1]
  money = parsed_respond[5].split(";")[1]
  TaskLog.new(:account_id => account.id, :task_id => task_id,
              :position => position, :xp_per_hour => xp,
              :money_per_hour => money, :respond => parsed_respond).save
  Log.new(computer_id: nil, account_id: account.id, text: parsed_respond).save
end

def mule_log(account, parsed_respond)
  item_amount = parsed_respond[2]
  mule = parsed_respond[3]

  MuleLog.new(:account_id => account.id, :mule => mule, :item_amount => item_amount).save
  Log.new(computer_id: nil, account_id: account.id, text: parsed_respond).save
end

def script_thread(client, account)
  begin
  while(!client.closed?)
    instruction_queue = []
    respond = client.gets
    if respond == nil
      client.puts "ok"
    else
      respond = respond.split(":")
      if respond[0] == "log"
        #get new instructions
        instruction_queue = Instruction.where(completed: false).select{|ins|ins.is_relevant && ins.account_id == account.id && ins.completed == false}
        log = Log.new(computer_id: nil, account_id: account.id, text: respond)
        log.save
        client.puts account_get_instruction_respond(instruction_queue)
      elsif respond[0] == "task_log"
        task_log(account, respond)
        client.puts "ok"
        #TODO, ADD XP GAINED TO account etc...
      elsif respond[0] == "mule_log"
        mule_log(account, respond)
        client.puts "ok"
        #TODO, ADD XP GAINED TO account etc...
      elsif respond[0] == "task_request"
        updateAccountLevels(respond[2], account)
        updateAccountQuests(respond[3], account)
        client.puts account_get_direct_respond(respond[0], account)
      elsif respond[0] == "banned"
        account.update(:banned => true)
        log = Log.new(computer_id: nil, account_id: account.id, text: respond)
        client.puts("DISCONNECT:1")
      elsif respond[0] == "mule_request"
        client.puts get_mule_respond(respond, account)
      else
        client.puts "ok"
      end
      end
  end
  rescue
    puts "Script Thread for: #{client} has been closed"
  end
end

def create_account_thread
  last_check = 0
  interval = 20
  generate_account = GenerateAccount.new
  begin
    loop do
      if Time.now > last_check + interval
        puts "lets create accounts"
        generate_account.create_accounts_for_all_computers
        last_check = Time.now
      else
        puts "next acc check: #{Time.now - (last_check + interval)}"
      end
      sleep(5.seconds)
    end
  rescue => error
    puts error
    puts "account threadloop ended"
    sleep(10.seconds)
    create_account_thread
  end
end

def computer_is_available(acc)
  return acc.computer_id != nil && acc.computer != nil && acc.computer.is_available_to_nexus && acc.computer.can_connect_more_accounts
end

def main_thread
  begin
  loop do
    puts "Main Thread loop"
    accounts = Account.where(banned: false, created: true)
    if !accounts.nil? && !accounts.blank?
      accounts = accounts.select{|acc| acc != nil && computer_is_available(acc)  && acc.is_available && acc.proxy != nil && acc.proxy.is_available && acc.schema != nil && acc.schema.get_suitable_task(acc) != nil && acc.account_type.name == "SLAVE"}
    end
    if !accounts.nil? && !accounts.blank?
      accounts = accounts.sort_by{|acc|acc.get_total_level}.reverse
      accounts.each do |acc|
      computer = acc.computer if acc.computer_id != nil
      if computer != nil && computer.is_available_to_nexus && computer.can_connect_more_accounts
      Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
          Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
          puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
          sleep(3.seconds)
      end
      end
    end

    sleep(10.seconds)
  end
  rescue => error
    puts error
    puts error.backtrace
    puts "Main loop ended"
    sleep(10.seconds)
    main_thread
  end
end


ActiveRecord::Base.establish_connection(db_configuration["development"])



server = TCPServer.new 43594 #Server bind to port 43594
#controllerThread = Thread.new(controller_thread)
def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")

@worlds = [397,398,399,425,426,430,431,433,434,435,437,438,439,440,451,452,453,454,455,456,457,458,459,469,470,471,472,473,474,475]

Thread::abort_on_exception = true
added_main_thread = false
added_account_thread = false
loop do
  if added_main_thread == false
    Thread.new do
      added_main_thread = true
      puts "new main thread"
      thread =  Thread.new{main_thread}
      thread.join
    end
  end
  if added_account_thread == false
    Thread.new do
      added_account_thread = true
      puts "new accout thread"
      thread =  Thread.new{create_account_thread}
      thread.join
    end
  end
  begin
    thread = nil
    puts "waiting for con"
    Thread.new server.accept do |client|

      puts "new client: #{client}"

      respond = client.gets.split(":")
        if respond[0] == "computer"
          #start new thread for computer
          ip = respond[2]
          name = respond[3].chomp!
          computer = Computer.find_or_create_by(:name => name)
          computer.update(:ip => ip)
          puts "New Computer Thread started for: #{computer}}"
          thread = Thread.fork{computer_thread(client, computer)}
          client.puts "connected:1"
        elsif respond[0] == "script"
          # start new thread for script
          login = respond[3].chomp
          if Account.where(:login => login) != nil && Account.where(:login => login).length > 0
            puts "Login: #{login}"
            account = Account.where(:login => login).first
            puts "account found:#{account.login}"
            if !account.created
              account.update(:created => true)
              account.save
            end
          else
            ip = respond[2]
            proxy = Proxy.find_or_initialize_by(:ip => ip)
            password = respond[4]
            username = respond[5]
            world = respond[6]
            account = Account.new(:login => login, :password => password, :username => username, :world => @worlds.sample,
                                  :computer => Computer.find_or_create_by(:name => "Suicide"), :account_type => AccountType.where(:name => "SLAVE").first,:mule => Account.where(:login => "ad_da_mig1@hotmail.com").first,
                                  :schema => Schema.find_or_create_by(:name => "Suicide"), :proxy => proxy, :should_mule => true)
            account.save
            puts "acount not found but created: #{account.login}"
          end
          puts "New Script Thread started for: #{respond[3]}"
          thread =  Thread.fork{script_thread(client, account)}
          client.puts "connected:1:#{account.username}"
        else
          puts "hello"
        end
      puts "joined new thread"
      #if thread != nil
     # thread.join
      #thread = nil
      #end
    end
  rescue Exception => ex
    puts ex
    puts "errooorororo"
  end
end





