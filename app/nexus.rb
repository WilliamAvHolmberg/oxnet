require 'socket'
require 'active_record'
require_relative '../app/models/application_record'
require_relative './models/account'
require_relative './models/proxy'
require_relative './models/log'


def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

def find_suitable_account
  return Account.all.select{|a| a.is_available}.first
end

def computer_thread(client)
  puts "started Thread"
  while(!client.closed?)
    mess = client.gets.split(":")
    puts mess.length
    if mess[0] == "account_request"
      account = find_suitable_account
      if account == nil
        puts "no account available"
        client.puts "account_request:0"
      else
        client.puts "account_request:1:" + account.login + ":" + account.password + ":" + account.proxy.ip
        log = Log.new(account_id: account.id, text: "Account Handed out to: #{client}")
        log.save
      end
    else
      client.puts "ok"
    end
    puts mess
  end
  puts "Computer Thread for: #{client} has been closed"
end

def script_thread(client)
  while(!client.closed?)
    mess = client.gets.split(":")
    puts mess.length
    if mess[0] == "account"
      client.puts account.login + ":" + account.password + ":" + account.proxy.ip
    elsif mess[0] == "assignment"
      client.puts "yayya"
      puts "sent ass"
    elsif mess[0] == "log"
      puts "assignment: " + mess[1] + " playTime: " + mess[2]
      client.puts "logged:fine"
    else
      client.puts "ok"
    end
    puts mess
  end
  puts "Script Thread for: #{client} has been closed"
end


ActiveRecord::Base.establish_connection(db_configuration["development"])



server = TCPServer.new 2099 #Server bind to port 2050

loop do
  client = server.accept

  mess = client.gets.split(":")
  if mess[0] == "computer"
    #start new thread for computer
    puts "New Computer Thread started for: #{client}"
    thread = Thread.new{computer_thread(client)}
    client.puts "connected:1"
  elsif mess[1] == "script"
    # start new thread for script
    puts "New Script Thread started for: #{client}"
    thread =  Thread.new{script_thread(client)}
    client.puts "New Script Thread Started"
  end
  thread.join
end




