require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require_relative './models/account'
require_relative './models/proxy'
require_relative './models/log'
require_relative './models/computer'
require_relative './models/instruction'
require_relative './models/instruction_type'
require_relative './models/script'



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

    puts ins.account
    puts ins.instruction_type
    puts ins.script
    puts ins.account.proxy
    puts ins.account.password

    if ins.instruction_type.name == "NEW_CLIENT" && ins.account_id == nil
      ins.update(:completed => true)
      puts "wrong"
    return "account_request:0"
    elsif ins.instruction_type.name == "NEW_CLIENT" && ins.account_id != nil
      ins.update(:completed => true)
      world = "424"
      res =  "account_request:1:" + ins.account.login + ":" + ins.account.password + ":" + ins.account.proxy.ip + ":" + world + ":" + ins.script.name
      puts "res is fine"
      if ins.computer != nil
        log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      else
        log = Log.new(account_id: ins.account.id, text: "Account:#{ins.account.login} Handed out to: #{ins.computer.name}")
      end
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

    if ins.instruction_type.name == "DISCONNECT"
      puts "dis"
      res =  "disconnect:1:"
      log = Log.new(computer_id: ins.computer_id, account_id: ins.account.id, text: "Account:#{ins.account.login} shall disconnect")
      log.save
      ins.update(:completed => true)
      return res
    else
      return "logged:fine"
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
      puts "sent"
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
    if respond[0] == "log"
      #get new instructionsp
      puts "name"
      instruction_queue = Instruction.all.select{|ins|ins.is_relevant && ins.account_id == account.id && ins.completed == false}
      log = Log.new(computer_id: nil, account_id: account.id, text: respond)
      log.save
      puts "logged"
      client.puts account_get_respond(instruction_queue)
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
  thread = nil
  puts "waiting for con"
  Thread.new server.accept do |client|
    puts "new client: #{client}"
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
      account = Account.find_or_create_by(:login => respond[3].strip!)
      puts "New Script Thread started for: #{respond[3]}"
      thread =  Thread.new{script_thread(client, account)}
      client.puts "connected:1"
    end
    puts "joined new thread"
    if thread != nil
    thread.join
    thread = nil
    end
  end
end





