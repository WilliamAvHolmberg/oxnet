require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'


class GenerateGear


  def initialize
    ActiveRecord::Base.establish_connection(db_configuration["development"])
    require_all("./models/")
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
    if slot == "body"
      return "chest"
    end

    if slot == "ammo"
      return "ammunition"
    end
    return slot
  end


  def generate_gear(account)
    slots = ["weapon", "legs","neck","body","feet","head","hands","ring","cape","shield"]

    gear = Gear.find_or_create_by(name: "#{account.username}")
    slots.each do |slot|

      if slot == "weapon"
        item = get_best_weapon(account)
      elsif slot == "neck"
        item = RsItem.find(8982) #amulet of str
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
    return account.stats.where(skill: Skill.where(name: "Defence").first).first.level
  end
  def get_strength_level(account)
    return account.stats.where(skill: Skill.where(name: "Strength").first).first.level
  end
  def get_attack_level(account)
    return account.stats.where(skill: Skill.where(name: "Attack").first).first.level
  end

  def get_ranged_level(account)
    return account.stats.where(skill: Skill.where(name: "Ranged").first).first.level
  end


  def get_best_weapon(account)
    best_weapon_type = get_best_weapon_type(account)
    return RsItem.where(tradeable: true, members: false,equipment_slot: "weapon").select{|i| i.attack_requirement == best_weapon_type.to_i && i.item_name.include?("scimitar")}.sample
  end

  def get_best_armour(account, slot)
    best_armour_type = get_best_armour_type(account)
    item = RsItem.where(tradeable: true, members: false,equipment_slot: slot).select{|i| i.range_requirement <= get_ranged_level(account) && i.defence_requirement == best_armour_type.to_i}.sample
    if item != nil
      return item
    end
    item = RsItem.where(tradeable: true, members: false,equipment_slot: slot).select{|i| i.defence_requirement < best_armour_type.to_i}.sample
    return item
  end

  def get_best_weapon_type(account)
    arr = [0,10,20,30,40]
    return arr.select{|item| item <= get_attack_level(account)}.max
  end

  def get_best_armour_type(account)
    arr = [0,10,20,30,40]
    return arr.select{|item| item <= get_defence_level(account)}.max
  end



  private
  def get_slot(slot)
    if slot == "body"
      return "chest"
    end

    if slot == "ammo"
      return "ammunition"
    end
    return slot
  end




end


#ge = GenerateGear.new
#ge.generate_gear(Account.find(34))
#computer = Computer.where(name: "Suicide").first
#generate_account = GenerateAccount.new
#generate_account.create_accounts(1)
#create_accounts_for_all_computers
