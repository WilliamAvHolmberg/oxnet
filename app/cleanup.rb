require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require 'acts_as_list'
require 'net/ping'
require_relative 'generate_account'
require_relative 'helpers/rs_worlds_helper'




def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])


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
    level = acc.stats.where(skill: Skill.where(name: "Woodcutting").first).first
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

def main_thread

  begin
    loop do
      puts "Main Thread loop"
      all_accounts = Account.where(banned: false, created: true)
      puts "below acc"
      accounts = all_accounts.sort_by{|acc|acc.get_total_level}.reverse
      if accounts != nil && accounts.length > 0
        accounts.each do |acc|
          computer = acc.computer if acc.computer_id != nil
          if computer != nil && computer.is_available_to_nexus && computer.can_connect_more_accounts
            Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
            Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
            puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
            sleep(1)
          end
        end
      end

      sleep(10)
    end
  rescue => error
    puts error.backtrace
    puts "Main loop ended"
    #main_thread
  end
end

def mule_withdraw_tasks
  mule_withdraw_tasks = MuleWithdrawTask.where(:created_at => (Time.now - 20.minutes..Time.now)).select{|task| !task.executed && task.is_relevant && !task.account!= nil }
  mule_withdraw_tasks.each do |task|
    puts Time.now
    puts task
    puts Time.now
  end
end

def transfer_accounts
  new_computer = Computer.all.select{|comp| comp.name == "William"}.first
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

def transfer_accounts
  old_eco = EcoSystem.find(1)
  new_eco = EcoSystem.find(2)
  proxy = Proxy.find(145)
  accounts = Account.where(banned: false, created: true, eco_system: new_eco, proxy: proxy)
  accounts.each do |acc|
    acc.update(eco_system: old_eco)
    acc.save
  end
end

def transfer_schemas
  accounts = Account.where(banned: false, created: true).where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
  new_schema = Schema.where(name: "RSPEER").first

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
    money_made += acc.get_money_deposited(acc.mule_logs)
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
  time = DateTime.parse("1/2/2019 0:00:00")
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
        #Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => acc.id, :script_id => Script.first.id).save
        #Log.new(computer_id: computer.id, account_id: acc.id, text: "Instruction created")
        puts "instruction for #{acc.username} to create new client at #{acc.computer.name}"
      end
    end
  end
end
#get_daily("Brandon")
#find_acc
test