require 'socket'
require 'active_record'
require_relative '../app/models/ication_record'
require 'net/ping'

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end



def computer_thread(client, computer)
  puts "started Thread for:#{computer.name} at ip:#{computer.ip}"
  puts " my computer id: #{computer.id}"
  i = 0
  while(!client.closed?)
    res = "#{computer.name}:#{i}"
    puts res
    client.puts res
  end
  puts "Computer Thread for: #{client} has been closed"
end




def script_thread(client, account)
  puts "started Thread for:#{account.login}"
  i = 0
  while(!client.closed?)
    res = "#{account.login}:#{i}"
    puts res
    client.puts res
    sleep(5)
  end
  puts "Script Thread for: #{client} has been closed"
end


def main_thread
  loop do
    puts "main thread running"
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





