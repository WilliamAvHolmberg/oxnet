require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require 'acts_as_list'




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


puts Account.all.size
puts TaskLog.all.size

noted_items = RsItem.all
noted_items.each do |item|
  equal_items = RsItem.where(:item_name => "#{item.item_name}")
  min_id = equal_items.map{|n| n.item_id}.min
  new_item = RsItem.where(item_id: min_id).first
  puts "#{new_item.item_name}:#{new_item.stackable}"
  equal_items = equal_items.select{|item| item.item_id != min_id}
  equal_items.each do |it|
    it.destroy
  end
end
#end