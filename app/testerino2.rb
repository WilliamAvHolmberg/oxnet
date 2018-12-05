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
  file = File.read("../item_defs.json")
  data_hash = JSON.parse(file)
  attack_req = data_hash[id]["requirements"][0]
  defence_req = data_hash[id]["requirements"][1]
  range_req = data_hash[id]["requirements"][4]
  puts defence_req
  puts range_req
  end
Account.destroy_all
#(0..10).each do |i|
  puts_prices(1135)
#end
