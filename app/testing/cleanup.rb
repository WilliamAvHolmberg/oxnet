require 'socket'
require 'active_record'
require_relative '../models/application_record'
require 'acts_as_list'
require 'net/ping'
require_relative '../generate_account'
require_relative '../generate_schema'
require_relative '../generate_gear'
require_relative '../helpers/rs_worlds_helper'
require 'devise'
require_relative "../../config/initializers/devise.rb"




def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("../models/")

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('../../../config/database.yml', __FILE__))
  YAML.load(File.read(db_configuration_file))
end
def connection_established?
  begin
    # use with_connection so the connection doesn't stay pinned to the thread.
    ActiveRecord::Base.connection_pool.with_connection {
      ActiveRecord::Base.connection.active?
    }
  rescue Exception
    false
  end
end

while !connection_established?
  puts "Connecting..."
  ActiveRecord::Base.establish_connection(db_configuration["development"])
  sleep 1.5.seconds
end
require_all("./models/")

def balance_worlds
  ga = GenerateAccount.new
  accounts = Account.where(banned: false, created: true)
  accounts.each do |acc|
    world = ga.get_random_world
    puts acc.username
    acc.update(world: world.number)
    acc.update(rs_world: world)
    acc.save
  end

end

def update_proxies(old, new)
  accounts = Account.where(banned: false, created: true, proxy_id: old)
  new_proxy = Proxy.find(new)
  accounts.each do |acc|
    acc.update(proxy: new_proxy)
    acc.save
  end
end

def give_accounts_to_vps
  batch_1 = Computer.where(name: "William").first
  accounts = batch_1.accounts.where(banned: false, created: true).select{|acc| (!acc.account_type.name.include?"MULE")}
  #vps = Computer.where(name: "VPS").first
  suicide = Computer.where(name: "Suicide").first
  x = 0
  accounts.each do |acc|
  #  puts x
    puts acc.username
    acc.update(computer: suicide)
    acc.save
   # x += 1
   # if x > 26
   #   break
   # end
  end
end



#create_account_thread
#accounts.each do |acc|
#  acc.stats.destroy_all
#  acc.quest_stats.destroy_all
#end


def fix_fucked_worlds
  worlds_to_change = [6, 7, 13, 15, 19, 20, 23, 24, 31, 32, 38, 39, 40, 47, 48, 55, 56, 57, 74, 78, 109, 110, 111, 118, 119, 120, 121, 122, 123, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146]
  available_worlds = RsWorld.select{|world| !worlds_to_change.include?(world.number.to_i)}
  worlds_to_change.each do |world|
    world += 300
    rs_world = RsWorld.where(number: world).first
    if rs_world != nil
      accounts = Account.where(banned: false, created: true,world: world)
      puts "#{rs_world}:#{accounts.size}"
      accounts.each do |acc|
        new_world = available_worlds.sample
        acc.update(rs_world: new_world)
        acc.update(world: new_world.number)
        acc.save
        puts acc.username
      end
    end
  end
end

def change_worlds_if_unavailable
  worlds_to_change = [71]
  available_worlds = RsWorld.select{|world| !worlds_to_change.include?(world.number.to_i)}

  worlds_to_change.each do |world|
    world += 300
    rs_world = RsWorld.where(number: world).first
    if rs_world != nil
      new_world = available_worlds.sample
      rs_world.update(number: new_world.number)
      rs_world.save
    end
  end
end

def get_accounts_filter
  accounts = Account.where(banned: false, created: true).select{|acc| acc.account_type != nil && acc.account_type.name == "SLAVE"}

  accounts = accounts.sort_by{|acc|acc.get_total_level}.reverse
  accounts.each do |acc|
    level = acc.stats_find("Woodcutting")
    if level != nil
      puts level.level
    end
  end
end


def play_with_last_seen_account
  acc = Account.find(7458)
  puts "Acc: #{acc.username}:#{acc.id}"
  puts "Last seen:#{acc.last_seen}"
  puts "Time online:#{acc.time_online}"
  puts "Time now: #{Time.now}"
  puts "Time now: #{Time.now}"
  log = Log.create(computer_id: nil, account_id: acc.id, text: "Test log")
  log.save
end

def play_with_last_seen_computer
  comp = Computer.find(1)
  puts "Comp: #{comp.name}:#{comp.id}"
  puts "Last seen:#{comp.last_seen}"
  puts "Time online:#{comp.time_online}"
  puts "Time now: #{Time.now}"
  log = Log.create(computer_id: comp.id, account_id: nil, text: "Test log")
  log.save
end

@generate_schema = GenerateSchema.new

def fillInEmptySchemas
  accounts = Account.where(banned: false, created: true)
  accounts = accounts.sort_by{|acc|acc.get_total_level}.reverse
  puts "fillInEmptySchemas"
  #if accounts != nil && accounts.length > 0
    accounts.each do |account|
      if account.schema == nil || account.schema.tasks.length == 0 || account.stats.find_by(skill: 1) == nil
        puts "Checking for #{account.username}"

        schema = Schema.where(default: false).sample
        account.update(schema: schema)
        account.schema = schema;

        puts "Assigned Schema Template:#{schema.id}"
        schema = @generate_schema.generate_schedule(account)
        account.update(schema: schema)
        account.schema = schema;
        account.save

      end
    end
  #end
end

def main_thread
  begin
    while !connection_established?
      puts "Connecting..."
      ActiveRecord::Base.establish_connection(db_configuration["development"])
      sleep 1.5.seconds
    end
    loop do
      puts "Main Thread loop"
      all_accounts = Account.where(banned: false, created: true)
      puts "below acc"
      accounts = all_accounts.sort_by{|acc|acc.get_total_level}.reverse
      if accounts != nil && accounts.length > 0
        accounts.each do |acc|
          computer = acc.computer if acc.computer_id != nil
          if computer != nil && computer.is_available_to_nexus && computer.can_connect_more_accounts
            Instruction.new(:instruction_type_id => InstructionType.find_by_name("NEW_CLIENT").id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
            Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
            puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
            sleep 1.seconds
          end
        end
      end

      sleep(10)
    end
  rescue => error
    puts error.backtrace
    puts "Main loop ended"
    #main_thread
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end

def mule_withdraw_tasks
  mule_withdraw_tasks = MuleWithdrawTask.where(:created_at => (Time.now.utc - 10.minutes.Time.now.utc)).select{|task| !task.executed && task.is_relevant && !task.account!= nil }
  mule_withdraw_tasks.each do |task|
    puts Time.now
    puts task
    puts Time.now
  end
end

def transfer_accounts
  new_computer = Computer.all.select{|comp| comp.name == "Suicide"}.first
  computers = Computer.all
  computers.each do |comp|
    accounts = comp.accounts.where(banned: false, created: true).select{|acc|acc.account_type.name != "MULE"}
    accounts.each do |acc|
      acc.update(computer: new_computer)
      acc.save
    end
  end
end

def add_eco_systems
  eco_system = EcoSystem.find(1)
  proxies = Proxy.all
  puts "start proxy"
  proxies.each do |proxy|
    proxy.update(eco_system: eco_system)
    proxy.save
  end

  puts "start comp"
  computers = Computer.all
  computers.each do |comp|
    comp.update(eco_system: eco_system)
    comp.save
  end

  puts "start acc"
  accounts = Account.where(banned: false, created: true)
  accounts.each do |acc|
    acc.update(eco_system: eco_system)
    acc.save
  end
end
def test_generate_account
  ga = GenerateAccount.new
  suicide = Computer.find(16)
  proxy = ga.get_random_proxy(suicide.eco_system)
  ga.create_account(suicide, proxy)
end



def transfer_schemas
  accounts = Account.where(banned: false, created: true)
  new_schema = Schema.where(name: "SUICIDE_DEFAULT").first

  accounts.each do |acc|
    acc.update(schema: new_schema)
    acc.save
  end
end

def get_suicide
  time = Time.parse("28/1/2019 0:00:00")
  computer = Computer.where(name: "Suicide").first
  accounts = Account.where(created: true, computer: computer, created_at: time..Time.now.end_of_day)
  money_made = 0
  accounts.each do |acc|
    money_made += acc.get_money_deposited(acc.mule_logs)
  end
  puts money_made
end
def get_brandon
  time = Time.parse("17/1/2019 0:00:00")
  computer = Computer.where(name: "Brandon").first
  accounts = Account.where(created: true, computer: computer, created_at: time..Time.now.end_of_day)
  money_made = 0
  accounts.each do |acc|
    money_made += acc.get_money_deposited(acc.mule_logs)
  end
  puts money_made
end



def get_hampus
  time = Time.parse("17/1/2019 0:00:00")
  computer = Computer.where(name: "BATCH1").first
  accounts = Account.where(created: true, computer: computer, created_at: time - 2.days..Time.now.end_of_day)
  money_made = 0
  accounts.each do |acc|
    money_made += acc.get_money_deposited(acc.mule_logs)
  end
  puts money_made
end
def get_money_made(accounts)
  money_made = 0
  accounts.each do |acc|
    if acc.money_made != nil
      money_made += acc.money_made
    end
  end
  return money_made
end
def clear_suicide
  accounts = Account.where(banned: false, created: true, computer: 14).select{|acc| !acc.shall_do_task}
  accounts.each do |acc|
    puts acc.username
    puts acc.last_seen
    acc.destroy
  end
end
def get_daily(name)
  time = DateTime.parse("15/2/2019 0:00:00")
  computer = Computer.where(name: name).first
  amount_of_loops = (DateTime.tomorrow - time).to_i
  puts amount_of_loops
  money_made = 0
  amount_of_loops.times do
    accounts = Account.where(created: true, computer: computer, created_at: time..time+1.days)
    money_made_day = get_money_made(accounts)
    puts "Money made #{time}: #{money_made_day}"
    money_made += money_made_day
    time = time + 1.days
  end
  puts "total money made: #{money_made}"
  average = money_made/ amount_of_loops
  acc_average = average/computer.max_slaves
  puts "average: #{average}, acc average: #{acc_average}"
end

def get_cool
  accounts = Account.where(banned: true, created: true)
  money_made =0
  accounts.each do |acc|
    money = acc.get_money_deposited
    puts "#{acc.username}:#{money}"
    money_made += money
  end
  puts money_made
end

def find_acc
  account = Account.where(username: "RunRestV")
  puts account.first.id
end

def computer_is_available(acc)
  return acc.computer_id != nil && acc.computer != nil && acc.computer.is_available_to_nexus && acc.computer.can_connect_more_accounts
end


def test
  accounts = Account.where(banned: false, created: true)
  if !accounts.nil? && !accounts.blank?
    accounts = accounts.select{|acc| acc != nil && computer_is_available(acc)  && acc.is_available && acc.proxy != nil && acc.proxy.is_available && acc.schema != nil && acc.schema.get_suitable_task(acc) != nil && acc.account_type.name == "SLAVE"}
  end
  if !accounts.nil? && !accounts.blank?
    accounts = accounts.sort_by{|acc|acc.get_total_level}.reverse
    accounts.each do |acc|
      computer = acc.computer if acc.computer_id != nil
      if computer != nil && computer.is_available_to_nexus && computer.can_connect_more_accounts
        #Instruction.new(:instruction_type_id => InstructionType.find_by_name("NEW_CLIENT").id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
        #Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
        puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
      end
    end
  end
end


def get_withdrawn
  time = DateTime.parse("20/2/2019 0:00:00")
  amount_of_loops = (DateTime.tomorrow - time).to_i
  puts amount_of_loops
  money_made = 0
  amount_of_loops.times do
    accounts = Account.where(account_type: AccountType.find(2), created: true)
    accounts.each do |acc|
      withdrawn = acc.get_total_money_withdrawn
      puts "#{acc.money_withdrawn}:#{withdrawn}"
      acc.update(money_withdrawn: withdrawn)
      acc.save
    end

    time = time + 1.days
  end
  #puts "total money made: #{money_made}"
  #average = money_made/ amount_of_loops
  #acc_average = average/accounts.size
  #puts "average: #{average}, acc average: #{acc_average}"
end

def account_created_info
  time = DateTime.parse("20/2/2019 0:00:00")
  amount_of_loops = (DateTime.tomorrow - time).to_i
  puts amount_of_loops
  amount_of_loops.times do
    puts "DAY:#{time}"
    accounts = Account.where(created_at: time..time+1.day)
    total_amount = accounts.size
    not_created = accounts.where(created: false)
    created = accounts.where(created: true)
    proxies = Proxy.all
    proxies.each do |proxy|
      accounts = not_created.where(proxy: proxy)
      puts "Proxy name: #{proxy.location}...failed #{accounts.size}"
    end
    puts "Created: #{created.size}....not created#{not_created.size}"
    time = time + 1.days
  end
end

def update_cooldown

proxies = Proxy.all
proxies.each do |proxy|
  proxy.update(unlock_cooldown: DateTime.now - 3.hours)
  proxy.save
end
end

def delete_accounts
  computer = Computer.where(name: "William").first
  new_computer = Computer.where(name: "Brandon").first
  accounts = Account.where(computer: computer, banned: false, created: true)
  accounts.each do |acc|
    puts acc.username
    acc.update(computer: new_computer)
    acc.save
  end
end

def update_proxy
  computer = Computer.where(name: "Suicide")
accounts = Account.where(banned: false, created: true, proxy: nil)
proxy = Proxy.find(1)
accounts.each do |acc|
  acc.update(proxy: proxy)
  acc.save
end
end

#update_proxy
#update_cooldown
#Hiscore.create(skill: Skill.where(name: "Fishing").first).save
x = 4
y = 12

def get_daily(name)
  time = DateTime.parse("8/3/2019 0:00:00")
  computer = Computer.where(name: name).first
  amount_of_loops = (DateTime.tomorrow - time).to_i
  puts amount_of_loops
  money_made = 0
  amount_of_loops.times do
    accounts = Account.where(created: true, computer: computer, created_at: time..time+1.days)
    money_made_day = get_money_made(accounts)
    puts "Money made #{time}: #{money_made_day}"
    money_made += money_made_day
    time = time + 1.days
  end
  puts "total money made: #{money_made}"
  average = money_made/ amount_of_loops
  acc_average = average/computer.max_slaves
  puts "average: #{average}, acc average: #{acc_average}"
end

def get_total_daily()
  time = DateTime.parse("20/3/2019 0:00:00")
  amount_of_loops = (DateTime.tomorrow - time).to_i
  puts amount_of_loops
  money_made = 0
  amount_of_loops.times do
    accounts = Account.where(created: true, created_at: time..time+1.days, account_type: AccountType.where(name: "SLAVE"))
    money_made_day = get_money_made(accounts)
    puts "Money made #{time}: #{money_made_day}"
    money_made += money_made_day
    time = time + 1.days
  end
  puts "total money made: #{money_made}"
  average = money_made/ amount_of_loops
  acc_average = average/240
  puts "average: #{average}, acc average: #{acc_average}"
end


def average_for_proxy
  proxies = Proxy.all
  accounts = Account.where(account_type: AccountType.where(name: "SLAVE").first)
  proxies.each do |proxy|
    location = proxy.location
    cur_accs = Account.where(proxy: proxy)
    money_made = 0
    cur_accs.each do |acc|
      money_made += acc.money_made if acc.money_made != nil
    end
    puts "Proxy: #{location}: Money_made: #{money_made} Accounts#{cur_accs.size} Average: #{money_made/cur_accs.size}"
  end
end

def average_money_right_now
  accounts = Account.where(banned: false, created: true).select{|acc| acc.is_connected}
  areas = Area.all
  money_per_hour = 0
  fails = 0
  suc = 0
  areas = []
  east_money = 0
  east_usage = 0
  west_money = 0
  west_usage = 0
  accounts.each do |acc|
    log = acc.task_logs.last
    cur_money = log.money_per_hour.to_i
    money_per_hour += cur_money
    if cur_money == 0
      fails +=1
    else
      suc+=1
    end
    puts money_per_hour
    area = log.task.action_area if log.task != nil
    if area != nil
      if area.name == "VARROCK_WEST_OAK_TREE"
        west_usage += 1
        west_money += cur_money
      end
      if area.name == "VARROCK_EAST_OAK_TREE"
        east_usage += 1
        east_money += cur_money
      end

      end
  end
  puts money_per_hour
  puts fails
  puts suc
  puts "EAST USAGE: #{east_usage} average: #{east_money/east_usage}"
  puts "WEST USAGE: #{west_usage} average: #{west_money/west_usage}"
end

def average_money_right_now
  tic
  online_players = Account.where(banned: false, created: true)
  task_logs = TaskLog
                  .includes(:task)
                  .select("DISTINCT ON (account_id) *")
                  .where(:created_at => (Time.now.utc - 20.minutes..Time.now.utc), account_id: online_players.pluck(:id))
                  .where.not(position: nil)
                  .order("account_id, created_at DESC")
                  .to_a
  toc
  areas = {}
  money_per_hour = 0
  task_logs.each do |log|
    cur_money = log.money_per_hour.to_i
    if cur_money != nil then money_per_hour += cur_money end
    area = log.task.action_area if log.task != nil

    if area != nil
      areas[area.name] = {money: 0, users: 0} if areas[area.name] == nil
      if cur_money != nil then areas[area.name][:money] += cur_money else areas[area.name][:money] += 0 end
      areas[area.name][:users] += 1
    end
  end

  puts money_per_hour

  areas.each do |area|
    money = area[1][:money]
    users = area[1][:users]
    average = money/users
    puts "#{area}....average:#{average}}"
  end

end

@start_time = 0

def tic
  @start_time = Time.now
end
def toc
  puts Time.now-@start_time
end

def generate_combat
  accounts = Account.where(computer: Computer.where(name: "Suicide").first, banned: false, created: true)
  org_schema = Schema.find(12842)
  ga = GenerateSchema.new
  accounts.each do |acc|
    acc.update(schema:org_schema)
    acc.save
    schema = ga.generate_schedule(acc)
    acc.update(schema: schema)
    acc.save
  end
end

def remove_items
  items = RsItem.where('item_name like ?', "%(t)%")
  items.each do |item|
    puts item.item_name
    item.delete
  end
end


def proxy_is_already_used(accounts, proxy)
  accounts.each do |acc|
    if acc.proxy.location == proxy.location
      return true
    end
  end
  return false
end

def get_recently_unlocked
  #recently_unlocked= Log.where("created_at > NOW() - INTERVAL '? minutes'", 10).where("text like ?", "%unlocked_account%").order('created_at DESC').limit(10)
  recently_unlocked = Log.where('computer_id IS NOT NULL AND created_at IS NOT NULL')
                           .where('created_at > ?', Time.now - 60.minutes).where("text like ?", "%unlocked_account%").limit(50)
  puts recently_unlocked.size
  recently_unlocked.each do |log|
    puts log.text
  end
end

def get_recently_cooldowns
  recently_unlocked= Log.where("text like ?", "%unlock_cooldown%").order('created_at DESC').limit(10)
  puts recently_unlocked.size
  recently_unlocked.each do |log|
    puts log.text
  end
end

def get_recently_unlock_instructions
  recently_unlocked= Log.where("text like ?", "%unlock_account%").order('created_at DESC').limit(10)
  puts recently_unlocked.size
  recently_unlocked.each do |log|
    puts log.text
  end
end

def delete_locked_accounts
  accounts = Account.where(banned: false, created: true, locked: true)
  accounts.each do |acc|
    acc.update(banned: true)
    acc.save
  end
end

def update_proxy_cooldown

  proxies = Proxy.all
  proxies.each do |proxy|
    proxy.update(cooldown: 0)
    proxy.save
  end
end


def set_max_slaves_for_proxy
  Proxy.all.each do |proxy|
  proxy.update(max_slaves: 1)
  proxy.save
  end
end
def generate_wc
  accounts = Account.where(banned: false, created: true)
  org_schema = Schema.find(2)
  accounts.each do |acc|
    acc.update(schema:org_schema)
    acc.save
  end
end







def test_get_woodcutting_task_respond(task, account)
  if task.bank_area != nil then bank_area = task.bank_area.coordinates else bank_area = "none" end
  if task.action_area != nil then action_area = task.action_area.coordinates else action_area = "none" end
  json_respond = {
      task_type:task.task_type.name,
      task_id: task.id,
      gear: task.gear.to_json,
      inventory: task.inventory.to_json,
      break_condition: task.break_condition_to_json,
      bank_area: bank_area,
      action_area: action_area,
      axe: task.axe.to_json,
      tree_name: task.treeName,
  }
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  res = "task_respond:1:#{json_respond}"
  return json_respond.to_json
end


@unavailable_worlds = [302, 308, 309, 310, 316, 317, 318, 325, 326, 333, 334, 341, 342, 349, 350, 358, 364, 365, 366, 371, 372, 373, 379, 380, 381, 382, 407, 408]


def get_least_used_worlds
  rs_worlds = RsWorld.where(members_only: false)
  worlds = Array.new
  current_lowest = 10000
  rs_worlds.each do |world|
    player_amount = world.get_amount_of_players
    if @unavailable_worlds.include?(world.number)
      puts "bad world"
    elsif player_amount < current_lowest
      worlds.clear
      worlds.push(world)
      current_lowest = player_amount
    elsif player_amount == current_lowest
      worlds.push(world)
    end
  end
  return worlds
end



def get_world
  current_world = world.chomp.to_i
  if @unavailable_worlds.include?(current_world)
    new_world = get_least_used_worlds.sample
    puts "------------------Changed world to #{new_world.number}"
    return new_world.number
  end
  puts "------------------Did not change world. world shall be #{current_world}"

  return current_world
end



def computer_get_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    puts "ACC: #{ins.account}"
    serverAddress = getServerAddress

    if ins.account != nil
      if ins.instruction_type.name == "CREATE_ACCOUNT"
        account = ins.account
        log = Log.new(account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out for the first time to: #{ins.computer.name}")
        log.save
        res =  "create_account:#{account.username}:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + "#{account.get_world}" + ":NEX" + ":http://#{serverAddress}:3000/accounts/#{account.id}/json"
        ins.update(:completed => true)
        account.proxy.update(last_used: DateTime.now.utc)
        return res
      elsif ins.instruction_type.name == "UNLOCK_ACCOUNT"
        account = ins.account
        log = Log.new(account_id: ins.account.id, text: "Account:#{ins.account.login} is gonna be unlocked: #{ins.computer.name}")
        log.save
        res =  "unlock_account:#{account.username}:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + "#{account.get_world}"  + ":NEX" + ":http://#{serverAddress}:3000/accounts/#{account.id}/json"
        ins.update(:completed => true)
        proxy = account.proxy
        proxy.update(unlock_cooldown: DateTime.now.utc + 10.minutes)
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
        #return computer_get_respond(instruction_queue) if (Time.now.utc - account.last_seen) < 10.seconds
        #res =  "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + world.chomp + ":NEX"
        res =  "account_request:1:#{account.username}:"  + ":http://#{serverAddress}:3000/accounts/#{account.id}/json"
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

def mail_is_available(email)
  domains = get_domains
  email_domain = "@#{email.split("@")[1]}"
  if domains.include?(email_domain)
    return true
  end
end
def get_domains
  begin
    if @lastGotMailDomains == nil || Time.now > @lastGotMailDomains + 900
      @mail_domains = []
      @lastGotMailDomains = Time.now
      doc = Nokogiri::HTML(open("https://temp-mail.org/en/option/change/"))
      doc.css('#domain option').each do |option|
        @mail_domains << option.attr('value')
      end
    end
  rescue => error
    puts error
    puts error.backtrace
  end
  return @mail_domains
end


def get_average
  proxies = Proxy.all
  proxies.each do |proxy|
    puts proxy.location
    accounts = Account.where(proxy: proxy, locked:true)
    amount_of_accounts = accounts.size
    puts "TOTAL AMOUNT OF ACCOUNTS #{accounts.size}"
    play_time = 0
    accounts.each {|acc| play_time += acc.get_time_online}
    puts "TOTAL PLAY TIME #{play_time}"
    if amount_of_accounts != 0
      puts "AVERAGE PLAY TIME #{play_time/amount_of_accounts}"
    end
    puts "................................................."
    puts "................................................."
    puts "................................................."


  end
end

@time_started = 0
def clock
  @time_started = Time.now
end

def unclock
  time_spent = Time.now - @time_started
  puts "Time spent:#{time_spent}"
end

def add_mule(mules, log)
  mule = log.account.username
  if !mules.include?(mule)
    mules.push(mule)
  end
  return mules
end

def analyse_test

  clock
  slaves = Account.where(banned: true, created_at: DateTime.now.beginning_of_day- 2.days..DateTime.now.end_of_day)

  only_nr1 = []
  time_nr1 = 0
  more_than_one = []
  time_more = 0
  slaves.each do |slave|
    username = slave.username
    puts "Slave: #{username}"
    mules = []
    MuleLog.where(mule: username).each do |log|
      add_mule(mules, log)
    end
    if mules.length == 1 && mules[0] == "BlaGnomSk"
      only_nr1.push(slave)
      time_nr1 += (slave.time_online) if slave.time_online != nil
    else
      more_than_one.push(slave)
      time_more += slave.time_online if slave.time_online != nil
    end
  end

  unclock


  size = only_nr1.size
  puts "#{size} only traded headmule and average time_online: #{time_nr1/size}"
  size = more_than_one.size
  puts "#{size} only traded headmule and average time_online: #{time_more/size}}"
end


def test_generate_schema
  schema_gen = GenerateSchema.new
  good_schema = Schema.find(2000)
  accounts = Account.where(banned: false, created: true)
  accounts.each do |acc|
    acc.update(schema: good_schema)
    new_schema = schema_gen.generate_schedule(acc)
    acc.update(schema: new_schema)
  end

end

test_generate_schema