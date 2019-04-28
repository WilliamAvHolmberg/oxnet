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
    last_task_logs = 1000
    last_logs = 1000
    unlock_instruction = InstructionType.find_by_name("UNLOCK_ACCOUNT")

    loop do

      if last_task_logs >= 1000
        print "Delete TaskLogs"
        last_task_logs = TaskLog.where("created_at < NOW() - '7 day'::INTERVAL").limit(last_task_logs + 1000).delete_all
        last_task_logs = 20000 if last_task_logs > 20000
        puts " - #{last_task_logs}"
         sleep(0.2)
      else
          last_task_logs += 50
      end

      if last_logs >= 1000
        print "Delete Logs"
        last_logs = Log.where("created_at < NOW() - '7 day'::INTERVAL").limit(last_logs + 1000).delete_all
        last_logs = 20000 if last_logs > 20000
        puts " - #{last_logs}"
        sleep(0.2)
      else
        last_logs += 50
      end

#       bad_worlds = "'305','310','317','321','326','328','332','354','369','381','402','405','406','419','423','437','379','469','470','380','451','335','384','455','436','459','456','452','383','458','453','457','452','397','454','399'"
#       print "Change Bad Worlds"
# #       result = ActiveRecord::Base.connection.update(
# # "UPDATE accounts SET
# #   rs_world_id=(SELECT id from rs_worlds WHERE number NOT IN (#{bad_worlds}) ORDER BY RANDOM() limit 1)
# #     where banned=false AND locked=false and (created=true OR last_seen > NOW() - '1 day'::INTERVAL) and
# #   (rs_world_id is NULL OR rs_world_id IN (SELECT id FROM rs_worlds WHERE number IN (#{bad_worlds})))")
#       result = ActiveRecord::Base.connection.update(
#           "UPDATE accounts SET
#   world=(SELECT number from rs_worlds WHERE number NOT IN (#{bad_worlds}) ORDER BY RANDOM() limit 1)
#     where banned=false AND (created=true OR last_seen > NOW() - '1 day'::INTERVAL) AND world IN (#{bad_worlds})")
#       puts " - Updated #{result}"


      banned = Account.where(banned:false, locked: true).update_all(banned:true)
      puts "Banned #{banned} locked accounts"
      deleted = Instruction.where(instruction_type_id: unlock_instruction.id).delete_all
      puts "Deleted #{deleted} unlock instructions"

      # Log.where(text: "[\"log\", \"0\"]").limit(10000).delete_all
      # Log.where(text: "[\"log\", \"0\r\n\"]").limit(10000).delete_all

      if(last_logs < 1000 && last_task_logs < 1000)
        sleep(30.0)
      else
        sleep(0.2)
      end
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