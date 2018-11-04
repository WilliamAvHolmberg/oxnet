require 'socket'
require 'active_record'
require_relative '../app/models/application_record'





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

itemiD = 0
itemName = "name"
File.readlines('items.txt').each do |line|
  newArray = line.split(" - ")
  itemID =  newArray[0].gsub(' ', '').chomp.to_i
  itemName = newArray[1].chomp
  item = RsItem.new(itemId: itemID, itemName: itemName)
  item.save
end
#array = string.split(':')
itemID = 0
itemName = "name"
#array.each do |item|
 # newArray = item.split(" - ")
  #itemID =  newArray[0].gsub(' ', '').chomp.to_i
  #3itemName = newArray[1].chomp
  #item = RsItem.new(itemId: itemID, itemName: itemName)
  #item.save
#end