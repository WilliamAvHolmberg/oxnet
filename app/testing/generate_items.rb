require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative '../models/application_record'
require 'json'







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

ActiveRecord::Base.establish_connection(db_configuration["development"])



def puts_prices(id)
  doc = HTTParty.get("https://www.osrsbox.com/osrsbox-db/items-json/#{id}.json")



  name = doc.parsed_response['name']
  if name != "name"
  id = doc.parsed_response['id']
  member = doc.parsed_response['members']
  stackable = doc.parsed_response['stackable']
  if doc.parsed_response['bonuses'] != nil then equipment_slot = doc.parsed_response['bonuses']['slot'] else equipment_slot = "None" end
  tradeable = doc.parsed_response['tradeable']
  exchange = doc.parsed_response['cost']
  puts "#{name},#{id},#{member}, #{stackable}, #{equipment_slot},  #{tradeable}, #{exchange}"
  item = RsItem.find_or_create_by(item_name: name, item_id: id, members: member, stackable:stackable,
                                  equipment_slot: equipment_slot,
                                   tradeable: tradeable,
                                  exchange: exchange)
  item.save
  else
    puts "bad item"
  end


end

def set_requirements(item, doc)
  if doc.parsed_response['equipment'] != nil
    equipment_slot = doc.parsed_response['equipment']['slot']
    item.update(equipment_slot: equipment_slot)
    item.update(attack_requirement: 1)
    item.update(strength_requirement: 1)
    item.update(defence_requirement: 1)
    item.update(range_requirement: 1)
    item.update(magic_requirement: 1)

    reqs = doc.parsed_response['equipment']["skill_reqs"]
    reqs.each do |req|
      skill = req['skill']
      level = req['level']
      if skill == "attack"
        item.update(attack_requirement: level)
      end
      if skill == "strength"
        item.update(strength_requirement: level)
      end
      if skill == "defence"
        item.update(defence_requirement: level)
      end
      if skill == "ranged"
        item.update(range_requirement: level)
      end
      if skill == "magic"
        item.update(magic_requirement: level)
      end
    end
    item.save
  end

end
def test_item(id)
  doc = HTTParty.get("https://www.osrsbox.com/osrsbox-db/items-json/#{id}.json")



  name = doc.parsed_response['name']
  if name != "name"
    id = doc.parsed_response['id']
    member = doc.parsed_response['members']
    tradeable = doc.parsed_response['tradeable']
    stackable = doc.parsed_response['stackable']
    noted = doc.parsed_response['noted']
    exchange = doc.parsed_response['cost']
    item = RsItem.find_or_create_by(item_name: name, item_id: id, members: member, stackable:stackable,
                                    noted: noted,
                                    tradeable: tradeable,
                                    exchange: exchange)
    set_requirements(item, doc)
    item.save
  end


end





test_item(4151)