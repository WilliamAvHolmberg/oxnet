require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative './models/application_record'
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




i = 0
slots = ["legs","neck","body","ammo","feet","head","hands","ring","cape","shield"]
#RsItem.where(tradeable: true, members: false).each do |item|
  #if (item.item_name.include? "Black") && item.equipment_slot != "weapon" && item.equipment_slot != "2h"
 #   #item.update(:defence_requirement => 20)
#    puts item.defence_requirement
#    puts item.item_name
#  end
#end
slots.each do |slot|
  item = RsItem.where(tradeable: true, members: false,equipment_slot: slot, defence_requirement: 0, range_requirement: 0).sample
  if item != nil
    puts "Slot:#{slot} item:#{item.item_name}"
  end
end


puts i
#(0..10).each do |i|
#puts_prices(1135)
#end
