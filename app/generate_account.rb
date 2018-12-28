require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'
require_relative 'generate_gear'
require_relative 'generate_schema'


class GenerateAccount
  public
    def create_account
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      password = "ugot00wned2"
      schema = Schema.where(name: "RSPEER").first #generate schema in the future
      mule = Account.where(username: "SirJolefon").first #not needed. random
      computer = Computer.all.sample
      proxy = Proxy.find(140)
      account = Account.new(:login => email, :password => password, :username => name, :world => world,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false)

      account.save
      ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
      ins.save
      puts "#{name} created for computer #{computer.name} with schema #{schema.name}"
    end

  def initialize
    ActiveRecord::Base.establish_connection(db_configuration["development"])
    require_all("./models/")
    @generate_gear = GenerateGear.new
    @generate_schema = GenerateSchema.new
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
    def find_available_proxy
      proxies = Proxy.all.select{|proxy| proxy.is_available}
      proxies.each do |proxy|
        puts "name:#{proxy.location}"
      end
      return proxies.sample
    end
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
      end
    end

  private
    def get_available_accounts_on_computer(computer)
      accounts = Account.where(computer_id: computer.id, banned:false, created:true)
      puts "Computer:#{computer.name}:#{accounts.length}"
      return accounts
    end
  private
    def get_least_used_worlds
      rs_worlds = RsWorld.all
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
    def get_random_domain
      @mail_domains = ["yahoo.com", "gmail.com", "hotmail.com", "live.se", "hotmail.co.uk"]
      return @mail_domains.sample
    end
  private
    def generate_name

      name = RsItem.order("RANDOM()").limit(1).first
      subbed_name = name.item_name.gsub(/[^a-zA-Z]/, '')
      sliced_name = subbed_name.slice(0, Random.new.rand(7..9))
      numbered_name = + sliced_name + Random.new.rand(1..30).to_s

      if numbered_name != nil
        return numbered_name
      else
        return generate_name
      end
    end
  private
    def generate_email(name)
      return name + "@" + get_random_domain
    end
  private
    def find_available_proxy
      return Proxy.select{|proxy| proxy.is_available}.sample
    end

  public



  public
    def create_account(computer, proxy)
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      password = "ugot00wned2"
      schema = Schema.where(name: "RSPEER").first #generate schema in the future
      mule = Account.where(username: "SirJolefon").first #not needed. random
      #proxy = find_available_proxy
      account = Account.new(:login => email, :password => password, :username => name, :world => world.number,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false, :rs_world => world)

      account.save
      new_schema = @generate_schema.generate_schedule(account)
      account.update(schema: new_schema)
      puts "id: #{account.id}:#{name} created for computer #{computer.name} with schema #{schema.name}"

      account.save
      if account.stats != nil
        account.stats.destroy_all
      end
      if account.quest_stats != nil
        account.quest_stats.destroy_all
      end
      account.save
      ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
      ins.save
      Stat.where(account_id: account.id).destroy_all
      QuestStat.where(account_id: account.id).destroy_all
    end

  public
  def create_accounts_for_computer(computer)
    account_threshold = computer.max_slaves
    current_amount_of_accounts = get_available_accounts_on_computer(computer)
    if should_do && current_amount_of_accounts != nil && current_amount_of_accounts.size < account_threshold
      puts current_amount_of_accounts.size
      create_account(computer, Proxy.find(140))
      #puts "lets create acc for #{computer.name}"
    end
  end

  def get_random_proxy
    return Proxy.all.select{|proxy| proxy.is_available}.sample
  end
  #todo fix size (13 atm)
  public
    def create_accounts_for_all_computers
      should_do = true
      computers = find_available_computers
      computers.each do |computer|
        account_threshold = computer.max_slaves
        current_amount_of_accounts = get_available_accounts_on_computer(computer)
        if should_do && current_amount_of_accounts != nil && current_amount_of_accounts.size < account_threshold
          puts current_amount_of_accounts.size
          proxy = get_random_proxy
          #create_account(computer, proxy)
            #puts "lets create acc for #{computer.name}"
            should_do = false
        end
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
#generate_account.create_accounts(1)
#create_accounts_for_all_computers
