require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require_relative './models/account'
require_relative './models/proxy'
require_relative './models/log'
require_relative './models/computer'
require_relative './models/instruction'
require_relative './models/instruction_type'



def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

def find_suitable_account
  return Account.all.select{|a| a.is_available}.first
end

def computer_get_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    if ins.instruction_type.name == "NEW_CLIENT" && ins.account == nil
      ins.update(:completed => true)
    return "account_request:0"
    elsif ins.instruction_type.name == "NEW_CLIENT" && ins.account.id != nil
      ins.update(:completed => true)
      world = "424"
      script = "NEXUS"
      res =  "account_request:1:" + ins.account.login + ":" + ins.account.password + ":" + ins.account.proxy.ip + ":" + world + ":" + script
      log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      log.save
      return res
    end
    return "logged:f"
  end
end

def account_get_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    if ins.instruction_type.name == "NEW_CLIENT" && ins.account == nil
      ins.update(:completed => true)
      return "account_request:0"
    elsif ins.instruction_type.name == "NEW_CLIENT" && ins.account.id != nil
      ins.update(:completed => true)
      world = "424"
      script = "NEXUS"
      res =  "account_request:1:" + ins.account.login + ":" + ins.account.password + ":" + ins.account.proxy.ip + ":" + world + ":" + script
      log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      log.save
      return res
    end
    return "logged:f"
  end
end


def computer_thread(client, computer)
  puts "started Thread for:#{computer.name} at ip:#{computer.ip}"
  puts " my computer id: #{computer.id}"
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
      #get new instructions
      instruction_queue = Instruction.all.select{|ins| ins.computer_id == computer.id && ins.completed == false && ins.is_relevant}
      puts "Log from: #{computer.name}:::log:#{respond}"
      log = Log.new(computer_id: computer.id, text: respond)
      log.save
      client.puts computer_get_respond(instruction_queue)
    else
      client.puts "ok"
    end
    puts respond
  end
  puts "Computer Thread for: #{client} has been closed"
end

def script_thread(client, account)
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
      #get new instructions
      instruction_queue = Instruction.all.select{|ins| ins.account.id == account.id && ins.completed == false && ins.is_relevant}
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
#controllerThread = Thread.new(controller_thread)
loop do
  begin
  client = server.accept

  respond = client.gets.split(":")
  if respond[0] == "computer"
    #start new thread for computer
    ip = respond[2]
    name = respond[3]
    computer = Computer.find_or_create_by(:name => name)
    computer.update(:ip => ip)
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
  rescue
    puts "error happened"
  end
end




