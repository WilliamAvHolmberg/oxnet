require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative '../app/models/application_record'
require 'json'







def require_all(_dir)
  Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

require_all("./models/")

@hello = 0
def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'config', 'database.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])

def generate_account
  account = Account.find_or_initialize_by(login: "testacc@gmail.com", username: "testacc",
                                          password: "testpass")
  puts account.username
  quests = Quest.all
  quests.each do |quest|
    QuestStat.find_or_create_by(quest: quest, account: account, completed: false)
  end

  account.quest_stats.each do |quest|
    puts "#{quest.quest.name}:#{quest.completed}"
  end

  Skill.all.each do |level|
    Stat.create(:skill => level, :level => 1, :account => account)
    #puts level
  end
  #account.levels.find_by(name: "Woodcutting").update(level: 99)
  account.update(schema: Schema.where(name: "Suicide").first)

  5.times do
    task = account.schema.get_suitable_task(account)
    if task == nil
      puts "No task available"
    elsif task.task_type.name == "QUEST"
      quest = Quest.find_or_initialize_by(name: task.quest.name)
      puts "Done quest: #{quest.name} #{quest.completed}"
    else
      level = account.stats.find_by(skill: task.skill)
      wanted_level = task.break_after
      puts (level.level.to_i..wanted_level.to_i).sample
      level.update(level: task.break_after)
      puts "#{level.skill.name} is now level :#{level.level}"

    end
  end
  #Task.all.each do |task|
  #  puts "Task: #{task.name}"
  #  puts "should do:#{task.should_do(account)}"
  #end

  account.destroy
end
i = 1
u = 30
puts (i..u).to_a.sample

#create new schema
# loop through all tasks
# check if can do task
#   can do? copy task and sample a new level goal
#   update levels that acc will have after level goal
# reset account stats
# give schema to account
#
#
#
#puts "Strength: #{account.levels.where(:name => "Strength").first.level}"
#Task.all.each do |task|
#  puts task.name
#end

#def get_available_tasks(account)
#  Task.all.each do |task|
#    if goal_level < account.get_level(task.level)
#    task.requirements.each do |req|
#      if req.get_level < account.get_level(req.get_skill)
#      end
#    end
#  end
#end

#(0..10).each do |i|
#puts_prices(1135)
#end
