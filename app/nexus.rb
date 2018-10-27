require 'socket'
require 'active_record'
require_relative '../app/models/application_record'


@hello = 0
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

def account_get_instruction_respond(instruction_queue)
  if instruction_queue.empty?
    return "logged:fine"
  else
    ins = instruction_queue.pop

    if ins.instruction_type.name == "DISCONNECT"
      puts "dis"
      res =  "DISCONNECT:1:"
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

def account_get_direct_respond(message, account)
  if message == nil
    return "logged:fine"
  else

   if message == "task_request"
      #one time do wc task
      # one time do break..
      # repeat (mod 2)
      #
      # get account.schema
      # check if any available task
      puts "before getting task"
      task = account.schema.get_suitable_task
      puts "after getting task"
      if task != nil
        puts "in task not nil"
        res = get_task_respond(task,account)
        return res
      else
        task_id = 0
        #task = get when next task starts
        res = "task_respond:1:BREAK:#{task_id}:TIME:1"
        return res
      end
    else
      return "logged:fine"
    end
    return "logged:f"
  end
end

def get_task_respond(task, account)
  task_type = task.task_type.name
  puts "task type good"
  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  puts "bank not good"
  action_area = task.action_area.coordinates
  axeID = task.axe.itemId
  axe_name = task.axe.itemName
  tree_name = task.treeName
  task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
  puts task_duration
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "all good saved log n all"
  return "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{axeID}:#{axe_name}:#{tree_name}:TIME:#{task_duration}"
end
def get_wc_task_respond(account)
  task = Task.first
  task_type = task.task_type.name

  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  action_area = task.action_area.coordinates
  axeID = task.axe.itemId
  axe_name = task.axe.itemName
  tree_name = task.treeName
  puts "fine untill break"
  break_condition = task.break_condition.name
  puts "fine after break condition:#{break_condition}"
  break_after = task.break_after
  puts "fine after break after :#{break_after}"
  puts "all fineasd:#{task.id}"
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  return "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{axeID}:#{axe_name}:#{tree_name}:#{break_condition}:#{break_after}"
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
    puts respond
    if respond[0] == "log"
      #get new instructionsp
      instruction_queue = Instruction.all.select{|ins|ins.is_relevant && ins.account_id == account.id && ins.completed == false}
      log = Log.new(computer_id: nil, account_id: account.id, text: respond)
      log.save
      client.puts account_get_instruction_respond(instruction_queue)
    elsif respond[0] == "TASK_LOG"
      log = Log.new(computer_id: nil, account_id: account.id, text: respond)
      log.save
      client.puts "ok"
      #TODO, ADD XP GAINED TO account etc...
    elsif respond[0] == "task_request"
      client.puts account_get_direct_respond(respond[0], account)
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
def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")
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





