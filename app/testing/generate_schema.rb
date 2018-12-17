require 'socket'
require 'active_record'
require 'HTTParty'
require 'Nokogiri'
require 'acts_as_list'
require_relative '../app/models/ication_record'
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


  Skill.all.each do |level|
    Stat.create(:skill => level, :level => 1, :account => account)
    #puts level
  end
  #account.levels.find_by(name: "Woodcutting").update(level: 99)
  account.update(schema: Schema.where(name: "Suicide").first)

  new_schema = Schema.create
  new_schema.update(name: "#{account.username}'s Schema'")
  while account.schema.get_suitable_task(account) != nil
    task = account.schema.get_suitable_task(account)
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
      level = account.stats.find_by(skill: task.skill)
      wanted_level = task.break_after
      our_level = ((level.level.to_i + 1)..wanted_level.to_i).to_a.sample
      level.update(level: our_level)
      puts "#{level.skill.name} is now level :#{level.level}"
      new_task = task.dup
      new_task.update(schema: new_schema, break_after: our_level, name: "#{account.username} --- #{new_task.name}")
      puts "#{new_task.name}, break after: #{new_task.break_after}, in schema #{new_task.schema.name}"
    end
    new_task.move_to_bottom

  end
  #Task.all.each do |task|
  #  puts "Task: #{task.name}"
  #  puts "should do:#{task.should_do(account)}"
  #end

  account.destroy
  return new_schema
end

puts generate_account.name


#create new schema
# loop through all tasks
# check if can do task
#   can do? copy task and sample a new level goal
#   update levels that acc will have after level goal
# reset account stats
# give schema to account
#
#
#generate_schema.rb
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
