require 'socket'
require 'active_record'
require 'httparty'
require 'nokogiri'
require_relative '../models/application_record'
require 'acts_as_list'
require 'net/ping'
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

def get_md5(string)
  return Digest::MD5.hexdigest string.downcase
end

def get_emails(md5)
  return HTTParty.get "https://privatix-temp-mail-v1.p.rapidapi.com/request/mail/id/#{md5}/",
                      headers:{
                          "X-RapidAPI-Host" => "privatix-temp-mail-v1.p.rapidapi.com",
                          "X-RapidAPI-Key" => "4c0e429fd6mshf2cbfeb2892c652p1f83bfjsn5f63eb9b0431"
                      }
end

def get_reset_mail_id(emails)
  for email in emails
    subject = email['mail_subject']
    if subject.downcase == "reset your jagex password"
      return email["mail_id"]
    end
  end
end

def read_email(email_id)
  return HTTParty.get "https://privatix-temp-mail-v1.p.rapidapi.com/request/source/id/#{email_id}/",
                         headers:{
                             "X-RapidAPI-Host" => "privatix-temp-mail-v1.p.rapidapi.com",
                             "X-RapidAPI-Key" => "4c0e429fd6mshf2cbfeb2892c652p1f83bfjsn5f63eb9b0431"
                         }
end

def get_reset_password_link(email_content)
  password_link = email_content.to_s
  password_id = password_link[/#{"code="}(.*?)#{'">reset'}/m, 1].chomp("\\")
  start_url = "https://secure.runescape.com/m=accountappeal/enter_security_code.ws?code="
  return "#{start_url}#{password_id}"
end

@google_recaptcha_api_key = '6Lcsv3oUAAAAAGFhlKrkRb029OHio098bbeyi_Hv'
@runescape_recover_url = 'https://secure.runescape.com/m=accountappeal/passwordrecovery'
@two_captcha_api_key = 'e31776b8685b07026204462c8919564e'

def get_captcha_response

  client = TwoCaptcha.new(@two_captcha_api_key)
  options = {
      googlekey: @google_recaptcha_api_key,
      pageurl: @runescape_recover_url
  }

  captcha = client.decode_recaptcha_v2(options)
  key = captcha.text
  puts key
  return key
end

def send_reset_password_post(url)
  puts "Requesting google recaptcha."
  google_recaptcha_key = get_captcha_response
  respond = HTTParty.post(url, body:{password: "ugot00wned5",
                                              confirm: "ugot00wned5",
                                              'submit': "Change+Password",
                                              'g-recaptcha-response': google_recaptcha_key
    })
  puts respond
  return respond
end

def analyse_respond(respond)
  bad_responses = ["You have been temporarily blocked from using this service"]
  if bad_responses.any? { |word| respond.include?(word) }
    return "BAD_RESPONSE"
  else
    return "PROBABLY GOOD???" #need more responses.
  end
end


def recover
  account = Account.find(43590)
  md5 = get_md5(account.login)
  puts "MD5 key:#{md5}"
  puts "Requesting emails."
  puts ".................."
  emails = get_emails(md5)
  puts "Recieved emails."
  puts "Amount of emails:#{emails.length}"
  puts "Checking if we have recieved reset mail."
  puts ".................."
  mail_id = get_reset_mail_id(emails)
  if mail_id != nil
    puts "Reset mail id:#{mail_id}"
    email_content = read_email(mail_id)
    puts "Getting reset password link."
    puts ".................."
    password_link = get_reset_password_link(email_content)
    puts "Password link:#{password_link}"
    respond = send_reset_password_post(password_link)
    puts respond.header

  else
    puts "No email recieved. Lets recover account."
  end
end

recover
