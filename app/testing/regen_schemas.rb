require 'socket'
require 'active_record'
require_relative '../models/application_record'
require 'acts_as_list'
require 'net/ping'
require_relative '../generate_account'
require_relative '../helpers/rs_worlds_helper'

args = Hash[ ARGV.flat_map{|s| s.scan(/--?([^=\s]+)(?:=(\S+))?/) } ]
if args.length == 0
  puts "No args parsed!"
  puts "regen_schemas.rb [-all] [-empty] [-offline] [-tasks=Woodcutting]"
  exit
end

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


@generate_schema = GenerateSchema.new


def computer_is_available(acc)
  return acc.computer_id != nil && acc.computer != nil && acc.computer.is_available_to_nexus && acc.computer.can_connect_more_accounts
end


if args.key?('all')
  mode = "all"
elsif args.key?('empty')
  mode = "empty"
elsif args.key?('offline')
  mode = "offline"
elsif args.key?('tasks')
  mode = "tasks"
else
  puts "No args parsed!"
  puts "regen_schemas.rb [-all] [-empty] [-offline] [-tasks=Woodcutting]"
  exit
end

offlineOnly = args.key?('offline')
emptyOnly = args.key?('empty') || !args.key?('all')
deleteTasks = args['tasks'] if args.key?('tasks')
if deleteTasks != nil
  deleteTasks = Regexp.new(deleteTasks, Regexp::IGNORECASE)
  puts "Going to delete tasks containing #{deleteTasks}"
end

default_schemas = Schema.all.to_a

accounts = Account.all_available_accounts
puts "Beginning..."
#if accounts != nil && accounts.length > 0
accounts.each do |account|
  if offlineOnly && !account.is_available
    next
  end
  # origina_schema = account.schema.original_id
  if deleteTasks != nil
    account.schema.tasks.all.each do |task|
      if deleteTasks =~ task.name
        puts "Deleted task '#{task.name}' for #{account.username}"
        task.task_logs.destroy_all
        task.requirements.destroy_all
        task.destroy
      end
    end
  end
  if emptyOnly && account.schema != nil
    nonQuests = 0
    account.schema.tasks.each do |task|
      if !task.task_type.name.include? "QUEST"
        nonQuests = nonQuests + 1
      end
    end
    next if nonQuests > 0
  end

  # next if account.account_type.name != "SLAVE"

  puts "Checking for #{account.username}"

  schema = Schema.next_to_use
  account.update(schema: schema)
  account.schema = schema;
  account.save

  puts "Assigned Schema Template:#{schema.id}"
  schema = @generate_schema.generate_schedule(account)
  account.update(schema: schema)
  account.schema = schema;
  account.save
end