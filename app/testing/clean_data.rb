require 'socket'
require 'active_record'
require_relative '../models/application_record'
require 'acts_as_list'
require 'net/ping'
require_relative '../generate_account'
require_relative '../helpers/rs_worlds_helper'

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
def connection_established?
  begin
    # use with_connection so the connection doesn't stay pinned to the thread.
    ActiveRecord::Base.connection_pool.with_connection {
      ActiveRecord::Base.connection.active?
    }
  rescue Exception
    false
  end
end

while !connection_established?
  puts "Connecting..."
  ActiveRecord::Base.establish_connection(db_configuration["development"])
  sleep 1.5.seconds
end
require_all("./models/")

def main_thread
  begin
    while !connection_established?
      puts "Connecting..."
      ActiveRecord::Base.establish_connection(db_configuration["development"])
      sleep 1.5.seconds
    end
    loop do

      puts "Delete TaskLogs"
      TaskLog.where("created_at < '#{7.days.ago}'").limit(10000).delete_all
       sleep(1)

      puts "Delete Logs"
      Log.where("created_at < '#{7.days.ago}'").limit(10000).delete_all
      sleep(1)

      # Log.where(text: "[\"log\", \"0\"]").limit(10000).delete_all
      # Log.where(text: "[\"log\", \"0\r\n\"]").limit(10000).delete_all

      sleep(0.2)
    end
  rescue => error
    puts error.backtrace
    puts "Main loop ended"
      #main_thread
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end


main_thread