require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require 'net/ping'

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
      ins.save
      world = ins.account.world
      account = ins.account

      res =  "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip.chomp + ":" + account.proxy.port.chomp + ":" + account.proxy.username.chomp + ":" + account.proxy.password.chomp + ":" + world.chomp + ":NEX"
      puts res
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


def get_mule_withdraw_task_respond(account)
  tasks = MuleWithdrawTask.all.select{|task| !task.executed  && !task.account!= nil && task.account.id == account.id && task.is_relevant}
  if tasks != nil && tasks.length > 0
    task = tasks[0]
  else
    return "DISCONNECT:1"
  end

  task_type = task.task_type
  item_id = task.item_id
  item_amount = task.item_amount
  world = task.world
  slave_name = task.slave_name

  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  res = "task_respond:1:#{task_type.name}:#{slave_name}:#{world.chomp}:#{item_id.chomp}:#{item_amount.chomp}"
  task.update(:executed => true)
  task.save
  puts res
  return res
end

def get_task_respond(task, account)
  case task.task_type.name
  when "WOODCUTTING"
    puts " res wc respond"
    return get_woodcutting_task_respond(task, account)
    #other cases, such as combat, druids.. etc
  when "MULE_WITHDRAW"
    puts "res mule respond"
    return get_mule_withdraw_task_respond(account)
  end
end

def account_get_direct_respond(message, account)
  if message == nil
    return "logged:fine"
  else

    puts "Task request"
    if account.account_type.name == "MULE"
      puts "mule"
      return get_mule_withdraw_task_respond(account)
    else if message == "task_request"
      puts "before getting task"
      task = account.schema.get_suitable_task
      puts "after getting task"
      if task == nil
        task_id = 0
        #task = get when next task starts
        res = "task_respond:1:BREAK:#{task_id}:TIME:1"
        return res
      else
        puts "found task"
        return get_task_respond(task, account)
      end
    else
      return "logged:fine"
    end
    return "logged:f"
    end
    end
end

def update_woodcutting_task(task, account)
  level = Level.find_by(name: "Woodcutting", account_id: account.id)
  puts "updating taskz"
  puts level.level
  puts level.name
  if level != nil && level.level.to_i > 0
    if level.level.to_i < 21
      puts "bronze axe"
      axe = RsItem.find_by(itemName: "Bronze axe")
    elsif level.level.to_i < 99
      puts "rune axe"
      axe = RsItem.find_by(itemName: "Rune axe")
    end
  end
  task.axe = axe
  task.save
  puts "updated task"
end

def get_woodcutting_task_respond(task, account)
  task_type = task.task_type.name
  update_woodcutting_task(task, account)
  if task.bank_area != nil
    bank_area = task.bank_area.coordinates
  else
    bank_area = "none"
  end
  action_area = task.action_area.coordinates
  axeID = task.axe.itemId
  axe_name = task.axe.itemName
  tree_name = task.treeName
  task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
  puts task_duration
  log = Log.new(computer_id: nil, account_id: account.id, text:"Task Handed Out: #{task.name}")
  log.save
  puts "sending resp"
  res = "task_respond:1:#{task_type}:#{task.id}:#{bank_area}:#{action_area}:#{axeID}:#{axe_name}:#{tree_name}:TIME:#{task_duration}"
  return res
end



def computer_thread(client, computer)
  puts "started Thread for:#{computer.name} at ip:#{computer.ip}"
  puts " my computer id: #{computer.id}"
  while(!client.closed?)
    respond = client.gets.split(":")
    #puts respond.length
    if respond[0] == "account_request"
      account = find_suitable_account
      if account == nil
        puts "no account available"
        client.puts "account_request:0"
      else
        world = "424"
        client.puts "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip + ":" + account.proxy.port + ":" + account.proxy.username + ":" + account.proxy.password + ":" + world + ":" + script
        log = Log.new(computer_id: computer.id, account_id: account.id, text: "Account:#{account.login} Handed out to: #{computer.name}")
        log.save
      end
    elsif respond[0] == "log"
      #get new instructions
      instruction_queue = Instruction.all.select{|ins| ins.computer_id == computer.id && !ins.completed && ins.is_relevant}
      if instruction_queue != nil
        puts "Inustruction queue length:#{instruction_queue.length}"
      end
      #puts "Log from: #{computer.name}:::log:#{respond}"
      log = Log.new(computer_id: computer.id, text: respond)
      log.save
      client.puts computer_get_respond(instruction_queue)
      #puts "sent"
    else
      client.puts "ok"
    end
    #puts respond
  end
  puts "Computer Thread for: #{client} has been closed"
end

def updateAccountLevels(string, account)
  string.slice! "skills;"
  array = string.split(';')
  array.each do |parsed|
    intern_parse = parsed.split(',')
    puts parsed
    name = intern_parse[0]
    level = intern_parse[1]
    puts name
    puts level
    account_level = Level.find_or_initialize_by(account_id: account.id, name: name)
    account_level.name = name
    account_level.level = level
    account_level.save
  end
end

def get_mule_respond(respond, account)
  mules = Account.all.select{|acc| acc.account_type != nil && acc.account_type.name == "MULE" && !acc.banned && (acc.proxy_is_available? || acc.proxy.ip.length < 5) }
  if mules != nil && mules.length > 0
    puts "we found mule"
    #create new isntruction for mule
    computers = Computer.all.select{|computer| computer.is_available_to_nexus}
    if computers != nil && computers.length > 0
      ins = Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computers.first.id, :account_id => mules[0].id, :script_id => Script.first.id)
      ins.save
      puts "created instruction"
      #new mule task
      mule = mules[0]
      item_id = respond[1]
      item_amount = respond[2]
      trade_name = respond[3]
      world = respond[4]
      puts world
      mule.update(:world => world)
      mule.save
      task = MuleWithdrawTask.new(:name => "Mule withdraw to :#{trade_name}", :task_type => TaskType.find_or_create_by(:name => "MULE_WITHDRAW"),  :account => mule, :item_id => item_id,
                                  :item_amount => item_amount, :slave_name => trade_name, :world => world, :area => Area.find_by(:name => "GRAND_EXCHANGE"))
      task.update(:executed => false)
      task.save
      return "SUCCESSFUL:#{mule.username.chomp}:#{mule.world}"
    end
  else
    puts "we found no mule"
  end
  puts "we found no computer"
  return "not successfull"
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
    elsif respond[0] == "task_log"
      log = Log.new(computer_id: nil, account_id: account.id, text: respond)
      log.save
      client.puts "ok"
      #TODO, ADD XP GAINED TO account etc...
    elsif respond[0] == "task_request"
      updateAccountLevels(respond[2], account)
      client.puts account_get_direct_respond(respond[0], account)
    elsif respond[0] == "banned"
      account.update(:banned => true)
      client.puts("DISCONNECT:1")
    elsif respond[0] == "mule_request"
      client.puts get_mule_respond(respond, account)
    else
      client.puts "ok"
    end
    puts respond
  end
  puts "Script Thread for: #{client} has been closed"
end


def main_thread
  loop do
    puts "main thread running"
    accounts = Account.all.select{|acc| acc.is_available && acc.schema != nil &&  acc.shall_do_task && !acc.banned && acc.proxy_is_available? &&  acc.account_type != nil && acc.account_type.name == "SLAVE"}
    if accounts != nil && accounts.length > 0
      puts "we found accounts."
      accounts.each do |acc|
        computers = Computer.all.select{|computer| computer.is_available_to_nexus}
          puts "account name: #{acc.login}"
          puts "type: #{acc.account_type.name}"
        if computers != nil && computers.length > 0
          puts "found computer: #{computers.first.name}"
          Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computers.first.id, :account_id => acc.id, :script_id => Script.first.id).save
          puts "Lets sleep"
          sleep(30)
          puts "done sleeping"
        else
          puts "no computer"
        end
      end
    end
    puts "no accounts"
    sleep(2)
  end
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



added_main_thread = false
loop do
  if added_main_thread == false
    Thread.new do
      added_main_thread = true
      puts "new main thread"
      thread =  Thread.new{main_thread}
      thread.join
    end
  end
  begin
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
  rescue Exception => ex
    puts ex
    puts "errooorororo"
  end
end





