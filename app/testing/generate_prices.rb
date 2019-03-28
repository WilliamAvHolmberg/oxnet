require 'socket'
require 'active_record'
require 'httparty'
require 'nokogiri'
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




def add_item(doc,id)

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


def add_price_to_item(doc,id)

  item_info = JSON.parse(doc.body)[id.to_s]
  if item_info != nil
    puts item_info['id']
    ge_price = item_info['overall_average'].to_i
    rs_item = RsItem.where(item_id: id).first
    if rs_item != nil
      rs_item.update(ge_price: ge_price)
      rs_item.save
    end
  end

end

def add_items(min,max)
  doc = HTTParty.get("https://rsbuddy.com/exchange/summary.json")

  (min..max).each do |i|
    puts i
    add_price_to_item(doc,i)
  end
end
def remove_items
  items = RsItem.where('item_name like ?', "%(t)%")
  items.each do |item|
    puts item.item_name
    item.delete
  end
end

def generate_items

  add_items(0,14000)
end
doc = HTTParty.get("https://rsbuddy.com/exchange/summary.json")

remove_items
add_items(0,10000)