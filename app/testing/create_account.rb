require 'socket'
require 'active_record'
require 'httparty'
require 'nokogiri'
require_relative '../models/application_record'
require 'acts_as_list'
require 'net/ping'
require_relative("http")
require_relative '../generate_account'
require_relative '../generate_schema'
require_relative '../generate_gear'
require_relative '../helpers/rs_worlds_helper'
require 'devise'
require_relative "../../config/initializers/devise.rb"
require 'digest'
require 'two_captcha'





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




def get_reset_password_link(email_content)
  password_link = email_content.to_s
  password_id = password_link[/#{"code="}(.*?)#{'">reset'}/m, 1].chomp("\\")
  #this url is later being redirected so we have to visit the link in order to get the real address
  start_url = "https://secure.runescape.com/m=accountappeal/enter_security_code.ws?code=" + password_id

  url = HTTParty.head(start_url, follow_redirects:true).request.last_uri.to_s
  return url
end

@google_recaptcha_api_key = '6Lcsv3oUAAAAAGFhlKrkRb029OHio098bbeyi_Hv'
@runescape_create_url = 'https://secure.runescape.com/m=account-creation/create_account'
@two_captcha_api_key = 'e31776b8685b07026204462c8919564e'

def get_captcha_response
  puts "Waiting for captcha response."
  puts "........."
  client = TwoCaptcha.new(@two_captcha_api_key)
  options = {
      googlekey: @google_recaptcha_api_key,
      pageurl: @runescape_create_url
  }

  captcha = client.decode_recaptcha_v2(options)
  key = captcha.text
  puts "Successfully received captcha response."
  return key
end

def create_account(account)
  puts "Creating account with email:#{account.login}"
  google_recaptcha_key = get_captcha_response
  respond = HTTParty.post(@runescape_create_url,follow_redirects: true,
                                                                  body:{
                                                                      email1: account.login,
                                                                      onlyOneEmail: '1',
                                                                      password1: account.password,
                                                                      onlyOnePassword: '1',
                                                                      day: 15,
                                                                      month: 07,
                                                                      year: 1998,
                                                                      'create-submit': 'create',
                                                                      'g-recaptcha-response': google_recaptcha_key
  }
    )
  return respond
end

def successfully_created(respond)
  good_response = "You can now begin your adventure with your new account"
  if respond.include?(good_response)
    return true
  end
  return false
end

def unlock_account(account)
  account.update(locked: false, created: true, assigned: false, banned: false)
end
def cc
  account = Account.where(created: false).first
  respond = create_account(account)
  if successfully_created(respond)
    puts "Successfully unlocked account!"
    unlock_account(account)
  else
    puts "Failed to create. Lets give cooldown of 10 minutes for proxy"
    #todo proxy cooldown
  end
end


account = Account.find(43598)
proxy = account.proxy


uri = URI.parse(@runescape_create_url)
http = Net::HTTP.SOCKSProxy(proxy.ip, proxy.port, proxy.username, proxy.password).start(uri.host, uri.port)
puts http.get(uri.path).body


