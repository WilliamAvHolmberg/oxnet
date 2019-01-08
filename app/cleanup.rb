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
  worlds_to_change = [6, 7, 13, 15, 19, 20, 23, 24, 31, 32, 38, 39, 40, 47, 48, 55, 56, 57, 74, 78, 109, 110, 111, 118, 119, 120, 121, 122, 123, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146]
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

play_with_last_seen_computer
#end