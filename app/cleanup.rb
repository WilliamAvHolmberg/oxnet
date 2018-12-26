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


accs = Account.where(banned: false, created: true, computer: Computer.find_by(:name => "VPS"))
new_comp = Computer.find_by(:name => "William")
puts new_comp.name
accs.each do |acc|
  puts acc.username
  acc.update(computer: new_comp)
  acc.save

end

#end