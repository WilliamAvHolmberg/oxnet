require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'
require_relative 'generate_gear'


class GenerateSchema

  def initialize
    while !connection_established?
      puts "Connecting..."
      ActiveRecord::Base.establish_connection(db_configuration["development"])
      sleep 1
    end
    require_all("./models/")
    @generate_gear = GenerateGear.new
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

    def wipeStats(account)
      account.stats.destroy_all
      Skill.all.each do |level|
        Stat.create(:skill => level, :level => 1, :account => account)
        #puts level
      end
    end
  def wipeQuests(account)
    account.quest_stats.destroy_all
    quests = Quest.all
    quests.each do |quest|
      quest_stat = QuestStat.find_or_create_by(quest: quest, account: account)
      quest_stat.update(completed: false)
    end
  end

    def generate_schedule(account)
      # sleep(0.01.in_milliseconds)
      puts "Generating Schedule for: " + account.username
      wipeQuests(account)
      wipeStats(account)
      account.reload

      new_schema = Schema.find_by_name("#{account.username}'s Schema'")
      if new_schema == nil
        new_schema = Schema.create
        new_schema.update(name: "#{account.username}'s Schema'", original_id: account.schema.id)
      end
      last_gear = nil
      last_weapon_type = 0
      last_armour_type = 0
      puts "#{account.schema.tasks.length} Available Tasks"
      task = nil
      while (task = account.schema.get_available_tasks(account).sample) != nil
        # sleep(0.01)
        # task = account.schema.get_available_tasks(account).sample
        if task == nil
          puts "No task available"
        elsif task.task_type.name == "QUEST"
          quest = Quest.find_or_initialize_by(name: task.quest.name)
          QuestStat.where(account: account, quest: quest).first.update(completed: true)
          new_task = task.dup
          new_task.update(schema: new_schema, name: "#{account.username} --- #{new_task.name}")
          puts "#{new_task.name} in schema #{new_task.schema.name}"

        else
          current_weapon_type = @generate_gear.get_best_weapon_type(account)
          current_armour_type = @generate_gear.get_best_armour_type(account)
          level = account.stats_find(task.skill_id)

          if level.level.to_i > 15
            if  (last_gear == nil ||current_weapon_type != last_weapon_type || current_armour_type != last_armour_type)
              gear = @generate_gear.generate_gear(account)
              if gear != nil
                gear.update(name: "#{account}:#{task.name}")
                puts "generating new gear"
              else
                puts "Gear came back nil"
              end
            else
              puts "keeping old gear"
              gear = last_gear
              gear.update(name: "#{account}:#{task.name}")
            end
          end

          wanted_level = task.break_after
          our_level = ((level.level.to_i + 1)..wanted_level.to_i).to_a.sample
          level.update(level: our_level)
          puts "#{level.skill.name} is now level :#{level.level}"
          new_task = task.dup
          new_task.update(schema: new_schema, break_after: our_level, name: "#{account.username} --- #{new_task.name}")
          puts "#{new_task.name}, break after: #{new_task.break_after}, in schema #{new_task.schema.name}"
          if gear != nil
           new_task.update(gear: gear)
          end
        end

        ##fix order of tasks
        if new_task != nil
          new_task.move_to_bottom
            last_gear = gear
            last_weapon_type = current_weapon_type
            last_armour_type = current_armour_type
        end
        account.reload
      end


      wipeStats(account)
      wipeQuests(account)
      account.save!
      ##set custom time intervals
      if account.schema.get_hours_per_day > 20
        account.schema.time_intervals.each do |time_interval|
          new_time = time_interval.dup
          new_time.update(schema: new_schema)
          new_time.save
        end
      else
        TimeInterval.create(start_time: Time.now, end_time: Time.now + 5.hours + rand(1..3).hours, schema: new_schema).save
      end
      return new_schema
    end

end


