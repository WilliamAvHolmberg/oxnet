require 'socket'
require 'active_record'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'
require 'net/ping'
require_relative 'generate_gear'


class GenerateSchema

  def initialize
    ActiveRecord::Base.establish_connection(db_configuration["development"])
    require_all("./models/")
    @generate_gear = GenerateGear.new
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


    def generate_schedule(account)

      puts account.username
      account.quest_stats.destroy_all
      account.stats.destroy_all
      quests = Quest.all
      quests.each do |quest|
        quest_stat = QuestStat.find_or_create_by(quest: quest, account: account)
        quest_stat.update(completed: false)
      end


      Skill.all.each do |level|
        Stat.create(:skill => level, :level => 1, :account => account)
        #puts level
      end


      new_schema = Schema.create
      new_schema.update(name: "#{account.username}'s Schema'")
      last_gear = nil
      last_weapon_type = 0
      last_armour_type = 0
      while account.schema.get_available_tasks(account) != nil && account.schema.get_available_tasks(account).length > 0
        task = account.schema.get_available_tasks(account).sample
        if task == nil
          puts "No task available"
        elsif task.task_type.name == "QUEST"
          quest = Quest.find_or_initialize_by(name: task.quest.name)
          QuestStat.where(account: account, quest: quest).first.update(completed: true)
          puts "Done quest: #{quest.name} #{account.quest_stats.where(quest: quest).first.completed}"
          new_task = task.dup
          new_task.update(schema: new_schema, name: "#{account.username} --- #{new_task.name}")
          puts "#{new_task.name} in schema #{new_task.schema.name}"

        else
          current_weapon_type = @generate_gear.get_best_weapon_type(account)
          current_armour_type = @generate_gear.get_best_armour_type(account)
          if last_gear == nil ||current_weapon_type != last_weapon_type || current_armour_type != last_armour_type
            gear = @generate_gear.generate_gear(account)
            puts "generating new gear"
          else
            puts "keeping old gear"
            gear = last_gear
          end


          gear.update(name: "#{account}:#{task.name}")
          level = account.stats.find_by(skill: task.skill)
          wanted_level = task.break_after
          our_level = ((level.level.to_i + 1)..wanted_level.to_i).to_a.sample
          level.update(level: our_level)
          puts "#{level.skill.name} is now level :#{level.level}"
          new_task = task.dup
          new_task.update(schema: new_schema, break_after: our_level, name: "#{account.username} --- #{new_task.name}")
          puts "#{new_task.name}, break after: #{new_task.break_after}, in schema #{new_task.schema.name}"
          new_task.update(gear: gear)
        end

        ##fix order of tasks
        new_task.move_to_bottom
        account.quest_stats.each do |quest|
          quest.update(completed: false)
        end

          last_gear = gear
          last_weapon_type = current_weapon_type
          last_armour_type = current_armour_type

      end

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


