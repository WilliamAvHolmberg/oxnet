require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require_relative './models/account'
require_relative './models/proxy'
require_relative './models/log'
require_relative './models/computer'


def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

def find_suitable_account
  return Account.all.select{|a| a.is_available}.first
end

def get_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    return instruction_queue.pop
  end
end

def computer_thread(client, computer)
  instruction_queue = []
  instruction_queue << "account_request"
  puts "started Thread for:#{computer.name} at ip:#{computer.ip}"
  while(!client.closed?)
    respond = client.gets.split(":")
    puts respond.length
    if respond[0] == "account_request"
      account = find_suitable_account
      if account == nil
        puts "no account available"
        client.puts "account_request:0"
      else
        world = "424"
        script = "NEXUS"
        client.puts "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip + ":" + world + ":" + script
        log = Log.new(computer_id: computer.id, account_id: account.id, text: "Account:#{account.login} Handed out to: #{computer.name}")
        log.save

      end
    elsif respond[0] == "log"
      puts "Log from: #{computer.name}:::log:#{respond}"
      log = Log.new(computer_id: computer.id, text: respond)
      log.save
      client.puts get_respond(instruction_queue)
    else






      client.puts "ok"
    end
    puts respond
  end
  puts "Computer Thread for: #{client} has been closed"
end

def script_thread(client)
  while(!client.closed?)
    instruction_queue = []
    respond = client.gets.split(":")
    puts respond.length
    if respond[0] == "account"
      client.puts account.login + ":" + account.password + ":" + account.proxy.ip + ":" + world + ":" + script
    elsif respond[0] == "task_request"
      client.puts "task_request:1:WOODCUTTING:99"
      puts "sent ass"
    elsif respond[0] == "log"
      puts "assignment: " + respond[1] + " playTime: " + respond[2]
      client.puts get_respond(instruction_queue)
    else
      client.puts "ok"
    end
    puts respond
  end
  puts "Script Thread for: #{client} has been closed"
end


ActiveRecord::Base.establish_connection(db_configuration["development"])



server = TCPServer.new 2099 #Server bind to port 2050

loop do
  client = server.accept

  respond = client.gets.split(":")
  if respond[0] == "computer"
    #start new thread for computer
    ip = respond[2]
    name = respond[3]
    computer = Computer.find_or_create_by(:name => name, :ip => ip)
    puts "New Computer Thread started for: #{computer}}"
    thread = Thread.new{computer_thread(client, computer)}
    client.puts "connected:1"
  elsif respond[0] == "script"
    # start new thread for script
    # respond[2] == account login
    puts "New Script Thread started for: #{respond[2]}"
    thread =  Thread.new{script_thread(client)}
    client.puts "connected:1"
  end
  thread.join
end




