require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'
require_relative 'generate_gear'
require_relative 'generate_schema'
require_relative 'functions'
require 'nokogiri'


class GenerateAccount

  def initialize
    while !connection_established?
      puts "Connecting..."
      ActiveRecord::Base.establish_connection(db_configuration["development"])
      sleep 1
    end
    require_all("./models/")
    @generate_gear = GenerateGear.new
    @generate_schema = GenerateSchema.new
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

  def require_all(_dir)
    Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
      require file
    end
  end



  @hello = 0
  def db_configuration
    db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
    YAML.load(File.read(db_configuration_file))
  end


  private
    # THIS FUNCTION WAS NOT BEING USED! Reduce confusion
    # def find_available_proxy
    #   proxies = Proxy.where(auto_assign: true).select{|proxy| proxy.is_available}
    #   proxies.each do |proxy|
    #     puts "name:#{proxy.location}"
    #   end
    #   return proxies.sample
    # end
  private
    def find_available_computers
      #check so max accounts is not reached
      computers = Computer.all.select{|computer| computer.is_connected}
      return computers
    end

  private
    def ban_accounts
      accounts = Account.where(banned:false, created:true).select{|acc| acc.account_type.name != "MULE"}
      accounts.each do |acc|
        puts acc.username
        acc.update(banned: true)
        if acc.schema.default = true #remember default is inverted...
          acc.schema.update(disabled: true)
        end
      end
    end

  private
    def get_unused_accounts_on_computer(computer)
      accounts = Account.where(computer_id: computer.id, banned:false, created:true, locked: false, assigned: false)
      puts "Computer:#{computer.name}:#{accounts.length} accounts"
      return accounts
    end
    def get_available_accounts_on_computer(computer)
      accounts = Account.where(computer_id: computer.id, banned:false, created:true, locked: false, assigned: true)
      puts "Computer:#{computer.name}:#{accounts.length} accounts"
      return accounts
    end
  private
    def get_least_used_worlds
      rs_worlds = RsWorld.where(members_only: false)
      worlds = Array.new
      current_lowest = 10000
      rs_worlds.each do |world|
        player_amount = world.get_amount_of_players
        if player_amount < current_lowest
          worlds.clear
          worlds.push(world)
          current_lowest = player_amount
        elsif player_amount == current_lowest
          worlds.push(world)
        end
      end
      return worlds
    end
  public
    def get_random_world
      return get_least_used_worlds.sample
    end


  private
  def get_domains
    begin
      if @lastGotMailDomains == nil || Time.now > @lastGotMailDomains + 900
        @mail_domains = []
        @lastGotMailDomains = Time.now
        doc = Nokogiri::HTML(open("https://temp-mail.org/en/option/change/"))
        doc.css('#domain option').each do |option|
          @mail_domains << option.attr('value')
        end
      end
    rescue => error
      puts error
      puts error.backtrace
    end
    if @mail_domains.nil? || @mail_domains.length == 0
      @mail_domains = ["@yahoo.com", "@gmail.com", "@outlook.com", "@hotmail.com", "@live.se", "@hotmail.co.uk"]
    end
    return @mail_domains
  end
  private
    def get_random_domain
      if @lastGotMailDomains == nil || Time.now > @lastGotMailDomains + 900
        @mail_domains = []
        @lastGotMailDomains = Time.now
        doc = Nokogiri::HTML(open("https://temp-mail.org/en/option/change/"))
        doc.css('#domain option').each do |option|
          @mail_domains << option.attr('value')
        end
      end
      if @mail_domains.nil? || @mail_domains.length == 0
        @mail_domains = ["@yahoo.com", "@gmail.com", "@outlook.com", "@hotmail.com", "@live.se", "@hotmail.co.uk"]
      end
      return @mail_domains.sample
    end
  public

    def canUnlockEmail(email)
      return false if email =~ /@(yahoo.com|gmail|outlook|live|hotmail)/
      domain = "@" + email.split("@").last
      return get_domains.include? domain
    end

    def generate_name

      name = RsItem.order(Arel.sql('random()')).limit(1).first #RANODOM() was deprecated
      name2 = RsItem.order(Arel.sql('random()')).limit(1).first
      name3 = RsItem.order(Arel.sql('random()')).limit(1).first
      subbed_name = name.item_name.gsub(/[^a-zA-Z]/, '')
      subbed_name2 = name2.item_name.gsub(/[^a-zA-Z]/, '')
      subbed_name3 = name3.item_name.gsub(/[^a-zA-Z]/, '')
      sliced_name = subbed_name.slice(0, Random.new.rand(3..4))
      sliced_name2 = subbed_name2.slice(0, Random.new.rand(3..4))
      sliced_name3 = subbed_name3.slice(0, Random.new.rand(1..2))
      numbered_name = + sliced_name + sliced_name2 + sliced_name3

      if numbered_name != nil
        return numbered_name
      else
        return generate_name
      end
    end
  private
    def generate_email(name)
      return name + get_random_domain
    end
  private
    def find_available_proxy
      return Proxy.where(auto_assign: true).select{|proxy| !proxy.has_cooldown && proxy.is_available}.sample
    end

  public



  public
    def get_number_of_mules
      account_type = AccountType.where(:name => "MULE")
      return Account.where(account_type: account_type, banned: false).where("created=true OR created_at > NOW()- INTERVAL '2 HOURS'").count
    end
    def create_account(computer, proxy)
      if proxy == nil
        puts "No proxy found for this ecosystem"
        return
      end
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      return create_account2(computer, proxy, name, email, world)
    end
    @use_default_computer = true
    def get_creation_computer(computer)
      creation_computer = Computer.where(name: "Testcomputer").first #hardcoded
      if creation_computer != nil && creation_computer.is_connected
        puts "USE DEFAULT COMPUTER: Testcomputer"
        return creation_computer.id
      end
      return computer.id
    end

    def get_amount_of_active_slaves
      return Account.where(banned: false, created: true, locked: false, assigned: true).size
    end
    def create_account2(computer, proxy, name, email, world)
      password = "ugot00wned2"
      schema = Schema.next_to_use
      mule = Account.where(username: "BlaGnomSk").first #not needed. random
      account_type = "SLAVE"
      amount_of_active_slaves = get_amount_of_active_slaves

      if get_number_of_mules < amount_of_active_slaves/4
        account_type = "MULE"
        schema = Schema.primary_schemas.order("max_slaves DESC").first
        other_mule = Account.where(banned:false, account_type: AccountType.where(:name => "MULE")).first
        if other_mule != nil
          proxy = other_mule.proxy
        else
          mule_proxy = Proxy.where(auto_assign: false).select{|proxy| proxy.is_available }.sample
          proxy = mule_proxy if mule_proxy != nil
        end
      end
      if(proxy == nil)
        return nil
      end
      # proxy = find_available_proxy
      account = Account.new(:eco_system => computer.eco_system, :login => email, :password => password, :username => name, :world => world.number,
                            :computer => computer, :account_type => AccountType.where(:name => account_type).first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false, :rs_world => world)

      account.save
      new_schema = @generate_schema.generate_schedule(account)
      account.update(schema: new_schema)
      puts "id: #{account.id}:#{name} created for computer #{computer.name} with schema #{schema.name}"

      if account.stats != nil
        account.stats.destroy_all
      end
      if account.quest_stats != nil
        account.quest_stats.destroy_all
      end
      account.save
      #TODO set proxy time
     # proxy.last_used = Time.now
      #proxy.save!
      ins = Instruction.new(:instruction_type_id => InstructionType.find_by_name("CREATE_ACCOUNT").id, :computer_id => get_creation_computer(computer), :account_id => account.id, :script_id => Script.first.id)
      ins.save
      Stat.where(account_id: account.id).destroy_all
      QuestStat.where(account_id: account.id).destroy_all
    end


  public

  def get_least_used_proxies(eco_system)
    available_proxies = nil
    Proxy.uncached do
      available_proxies = Proxy.where(eco_system: eco_system, auto_assign: true)
                              .select{|proxy| proxy.is_available && !proxy.has_cooldown}
    end
    proxies = Array.new
    current_lowest = 10000
    available_proxies.each do |proxy|
      account_amount = proxy.get_active_accounts.size
      next if account_amount >= proxy.max_slaves
      if account_amount < current_lowest
        proxies.clear
        proxies.push(proxy)
        current_lowest = account_amount
      elsif account_amount == current_lowest
        proxies.push(proxy)
      end
    end
    return proxies
  end

  def get_random_proxy(eco_system)
    return get_least_used_proxies(eco_system).sample
  end
  public
    def get_available_accounts
      return Account.where(banned: false, created: true, locked: false, assigned: false).select{|acc| acc.shall_do_task}.to_a
    end
    def create_accounts_for_all_computers
      available_accounts = get_available_accounts
      create_backup = false
      computers = find_available_computers.shuffle

      computers.each do |computer|
        account_threshold = computer.max_slaves
        current_amount_of_accounts = get_available_accounts_on_computer(computer).select{|account| account.shall_do_task}
        accounts_needed = account_threshold - current_amount_of_accounts.length
        create_backup = accounts_needed > 0
        puts "NEEDED? #{accounts_needed > 0}"
        accounts_needed.times do
          if available_accounts.length > 0
            account = available_accounts.pop
            account.update(computer: computer, assigned: true)
          end
        end
      end
      create_backups_for_all_computers(create_backup)
    end
  private
    def create_backups_for_all_computers(create_backup)
      if !create_backup
        puts "lets not create backup"
        return
      end
      computer = Computer.find(1) #testcomputer. Default computer for account creation
      puts "computer is nil #{computer == nil}"
      if computer != nil
        #account_threshold = computer.max_slaves #only create one account.
        #puts account_threshold
        #current_amount_of_accounts = get_unused_accounts_on_computer(computer)
        #puts current_amount_of_accounts
        #if current_amount_of_accounts == nil || current_amount_of_accounts.size < account_threshold
        puts "lets get proxies"
        proxies = get_least_used_proxies(computer.eco_system).shuffle
        proxies.each do |proxy|
          # proxy = get_random_proxy(computer.eco_system)
          # Check if we already have an instruction with this proxy due
          existing_instructions = Instruction.get_uncompleted_instructions_60
                                      .where(instruction_type_id: InstructionType.find_by_name("CREATE_ACCOUNT").id).includes(:account)
          next if existing_instructions.any? { |ins| ins.is_relevant && ins.account.proxy_id == proxy.id}
          create_account(computer, proxy)
          proxy.update(last_used: DateTime.now.utc)
          #puts "lets create acc for #{computer.name}"
          # should_do = false
          break #exit loop, only do one account
        end
          #puts "lets create acc for #{computer.name}"
        #else
         # puts "current amount of accounts is wrong"
        #end
      end
    end
  #todo fix size (13 atm)
  public
  def create_accounts(number, computer, proxy)

      number.times do
        create_account(computer, proxy)
    end
  end


end


#computer = Computer.where(name: "Suicide").first
#generate_account = GenerateAccount.new
#name = generate_account.generate_name
#puts name
#generate_account.create_accounts(1)
#create_accounts_for_all_computers
