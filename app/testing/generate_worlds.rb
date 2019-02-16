require 'socket'
require 'active_record'
require 'HTTParty'
require 'open-uri'
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


def add_worlds
url = 'http://oldschool.runescape.com/slu'
html = open(url)
doc = Nokogiri::HTML(html)
servers = doc.css('.server-list')
worlds = []
(0..400).each do |i|
  tr = bla = servers.css('tr')[i]
  if tr != nil
    td = tr.css('td')
    test = td[0]
    if test != nil
      world = td[0].text.gsub("Old", " ").chomp.gsub("School", " ").to_i + 300
      members = td[3].text
      if members == "Members"
        members = true
      else
        members = false
      end
      req = td[4].text

      if req.include? " total"
        req = true
      else
        req = false
      end

      if !req && world != 0
        puts "world: #{world} members: #{members} req: #{req}"
        RsWorld.create(number: world, members_only: members).save!
      end
    end
  end
end
end

def remove_worlds
  RsWorld.destroy_all
end

add_worlds

#world = entries.css('table')[0].css('tr')[1].css('td')[0].text.gsub("\Old School ", ' ').to_i
#end
#json = JSON.pretty_generate(bridges)
#File.open("data.json", 'w') { |file| file.write(json) }




#test_item(4151)