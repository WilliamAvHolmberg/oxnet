require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'


class GenerateAccount



  def initialize
    ActiveRecord::Base.establish_connection(db_configuration["development"])
    require_all("./models/")
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
    def get_random_world
      @worlds = [397,398,399,425,426,430,431,433,434,435,437,438,439,440,451,452,453,454,455,456,457,458,459,469,470,471,472,473,474,475]
      return @worlds.sample
    end

  private
    def get_random_domain
      @mail_domains = ["yahoo.com", "gmail.com", "hotmail.com", "live.se", "hotmail.co.uk"]
      return @mail_domains.sample
    end
  private
    def generate_name

      name = RsItem.order("RANDOM()").limit(1).first
      subbed_name = name.itemName.gsub(/[^a-zA-Z]/, '')
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
    def create_account
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      password = "ugot00wned2"
      schema = Schema.where(name: "Suicide").first #generate schema in the future
      mule = Account.where(username: "SirJolefon").first #not needed. random
      computer = find_available_computers.sample
      proxy = Proxy.find(140)
      account = Account.new(:login => email, :password => password, :username => name, :world => world,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false)

      account.save
      ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
      ins.save
      puts "#{name} created for computer #{computer.name} with schema #{schema.name}"
    end

    def create_account(computer)
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      password = "ugot00wned2"
      schema = Schema.where(name: "Suicide").first #generate schema in the future
      mule = Account.where(username: "SirJolefon").first #not needed. random
      proxy = Proxy.find(140)
      account = Account.new(:login => email, :password => password, :username => name, :world => world,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false)

      account.save
      ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
      ins.save
      puts "#{name} created for computer #{computer.name} with schema #{schema.name}"
    end
  private
    def create_account(computer, boolean)
      name = generate_name
      email = generate_email(name)
      world = get_random_world
      password = "ugot00wned2"
      schema = Schema.where(name: "Suicide").first #generate schema in the future
      mule = Account.where(username: "SirJolefon").first #not needed. random
      #proxy = find_available_proxy
      proxy = Proxy.find(140)
      account = Account.new(:login => email, :password => password, :username => name, :world => world,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => proxy, :should_mule => true, :created => false)

      account.save
      ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
      ins.save
      new_schema = generate_schedule(account)
      account.update(schema: new_schema)
      puts "#{name} created for computer #{computer.name} with schema #{schema.name}"
    end

  #todo fix size (13 atm)
  public
    def create_accounts_for_all_computers
      account_threshold = 14
      computers = find_available_computers
      computers.each do |computer|
        current_amount_of_accounts = get_available_accounts_on_computer(computer)
        if current_amount_of_accounts != nil && current_amount_of_accounts.size < account_threshold
          puts current_amount_of_accounts.size
          amount_of_accounts_to_create = account_threshold - current_amount_of_accounts.size
          amount_of_accounts_to_create.times do
            create_account(computer, true)
            #puts "lets create acc for #{computer.name}"
          end
        end
      end
    end
  private
    def generate_schedule(account)

      puts account.username
      quests = Quest.all
      quests.each do |quest|
        QuestStat.find_or_create_by(quest: quest, account: account, completed: false)
      end


      Skill.all.each do |level|
        Stat.create(:skill => level, :level => 1, :account => account)
        #puts level
      end


      new_schema = Schema.create
      new_schema.update(name: "#{account.username}'s Schema'")
      while account.schema.get_suitable_task(account) != nil
        task = account.schema.get_suitable_task(account)
        if task == nil
          #puts "No task available"
        elsif task.task_type.name == "QUEST"
          quest = Quest.find_or_initialize_by(name: task.quest.name)
          QuestStat.where(account: account, quest: quest).first.update(completed: true)
         # puts "Done quest: #{quest.name} #{account.quest_stats.where(quest: quest).first.completed}"
          new_task = task.dup
          new_task.update(schema: new_schema, name: "#{account.username} --- #{new_task.name}")
          #puts "#{new_task.name} in schema #{new_task.schema.name}"

        else
          level = account.stats.find_by(skill: task.skill)
          wanted_level = task.break_after
          our_level = ((level.level.to_i + 1)..wanted_level.to_i).to_a.sample
          level.update(level: our_level)
          #puts "#{level.skill.name} is now level :#{level.level}"
          new_task = task.dup
          new_task.update(schema: new_schema, break_after: our_level, name: "#{account.username} --- #{new_task.name}")
          #puts "#{new_task.name}, break after: #{new_task.break_after}, in schema #{new_task.schema.name}"
        end
        new_task.move_to_bottom
        account.quest_stats.each do |quest|
          quest.update(completed: false)
        end



       # puts "schema generated"
      end
      #Task.all.each do |task|
      #  puts "Task: #{task.name}"
      #  puts "should do:#{task.should_do(account)}"
      #end

      account.stats.each do |skill|
        skill.update(level: 1)
      end
      account.schema.time_intervals.each do |time_interval|
        new_time = time_interval.dup
        new_time.update(schema: new_schema)
        new_time.save
      end
      return new_schema
    end

end

#computer = Computer.where(name: "Suicide").first
#computer = Computer.where(name: "VPS").first
#puts computer.name
#5.times do
#create_account(computer, true)
 # end
#create_accounts_for_all_computers
