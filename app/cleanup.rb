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


#ga = GenerateAccount.new

#account = Account.where(banned: false, created: true).select{|acc| acc.world == "372"}

#account.each do |acc|
#  puts acc.username
#  world = RsWorld.where(number: 397).first
#  acc.update(rs_world: world)
#  acc.update(world: world.number)
#  acc.save
#end

#accounts.each do |acc|
#  acc.stats.destroy_all
#  acc.quest_stats.destroy_all
#end


#end