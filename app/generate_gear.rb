require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'


class GenerateGear


  def initialize
    while !connection_established?
      puts "Connecting..."
      ActiveRecord::Base.establish_connection(db_configuration["development"])
      sleep 1
    end
    require_all("./models/")
  end

  def connection_established?
    begin
      # use with_connection so the connection doesn't stay pinned to the thread.
      ActiveRecord::Base.connection_pool.with_connection {
        ActiveRecord::Base.connection.active?
      }
    rescue SystemExit, Interrupt
      raise
    rescue Exception
      false
    end
  end

  def require_all(_dir)
    Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
      require file
    end
  end

  def db_configuration
    db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
    YAML.load(File.read(db_configuration_file))
  end


  def get_slot(slot)

    return slot
  end


  def generate_gear(account)
    slots = ["weapon", "legs","neck","chest","feet","head","hands","ring","cape","shield"]
    # sleep(0.01.seconds) #helped heaps with database issues
    gear = Gear.find_or_create_by(name: "#{account.username}")
    slots.each do |slot|

      if slot == "weapon"
        item = get_best_weapon(account)
      elsif slot == "neck"
        amulets = [
            1725
          ]
        item = RsItem.find(amulets.sample) #amulet of str
      else
        item = get_best_armour(account,slot)
      end

      if item != nil
        puts "Slot:#{slot} item:#{item.item_name}"
        gear.update("#{get_slot(slot.to_s)}" => item)
      end
    end
    gear.save
    return gear
  end

  def get_defence_level(account)
    return account.stats_find("Defence").level
  end
  def get_strength_level(account)
    return account.stats_find( "Strength").level
  end
  def get_attack_level(account)
    return account.stats_find("Attack").level
  end

  def get_ranged_level(account)
    return account.stats_find("Ranged").level
  end

  ##quick fix with item_id < 10000 to not count new items added. They have wrong def req
  def get_best_weapon(account)
    best_weapon_type = get_best_weapon_type(account)
    return RsItem.where(tradeable: true, members: false,equipment_slot: "weapon").select{|i| i.item_id < 10000 && i.attack_requirement == best_weapon_type.to_i && i.item_name.include?("scimitar")}.sample
  end

  def get_best_armour(account, slot)
    best_armour_type = get_best_armour_type(account)
    item = RsItem.where(tradeable: true, members: false,equipment_slot: slot).select{|i| i.item_id < 10000 && i.range_requirement <= get_ranged_level(account) && i.defence_requirement == best_armour_type.to_i}.sample
    if item != nil
      return item
    end
    item = RsItem.where(tradeable: true, members: false,equipment_slot: slot).select{|i| i.item_id < 10000 && i.defence_requirement < best_armour_type.to_i}.sample
    return item
  end

  def get_best_weapon_type(account)
    arr = [1,10,20,30,40]
    attack = get_attack_level(account)
    return arr.select{|item| item <= attack}.max
  end

  def get_best_armour_type(account)
    arr = [1,10,20,30,40]
    defence = get_defence_level(account)
    return arr.select{|item| item <= defence}.max
  end







end


#ge = GenerateGear.new
#ge.generate_gear(Account.find(34))
#computer = Computer.where(name: "Suicide").first
#generate_account = GenerateAccount.new
#generate_account.create_accounts(1)
#create_accounts_for_all_computers
