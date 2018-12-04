require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'







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
  item = RsItem.find_or_create_by(itemName: name, itemId: id, members: member, stackable:stackable,
                                  equipment_slot: equipment_slot,
                                   tradeable: tradeable,
                                  exchange: exchange)
  item.save
  else
    puts "bad item"
  end


end
Task.destroy_all
#RsItem.destroy_all
# #get all items which slot is not None
# add column defence req
# add column attack req
# add column str req
# if task.gear == nil
# get personal random gear
# personal random gear should be initialized when account is created
# generate schema when account is created
# generate tasks when account is created
# generate gears when account is created
#(12705..18000).each do |i|
#  puts_prices(i)
#end

