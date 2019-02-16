require 'socket'
require 'active_record'
require_relative '../app/models/ication_record'
require 'net/ping'
require 'acts_as_list'
require_relative 'generate_account'

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end



ActiveRecord::Base.establish_connection(db_configuration["development"])



server = TCPServer.new 43594 #Server bind to port 43594
#controllerThread = Thread.new(controller_thread)
def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")

@worlds = [397,398,399,425,426,430,431,433,434,435,437,438,439,440,451,452,453,454,455,456,457,458,459,469,470,471,472,473,474,475]

Thread::abort_on_exception = true
added_main_thread = false
last_check = 0
interval = 10.minute
generate_account = GenerateAccount.new
loop do
  if Time.now > last_check +  interval
    last_check = Time.now
    puts "hello"
    generate_account.create_accounts_for_all_computers
  else

    puts "no hello"
    puts "next check: #{(last_check + interval - Time.now)}"
  end
  sleep(1)
end





