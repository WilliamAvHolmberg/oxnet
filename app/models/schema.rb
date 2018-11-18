class Schema < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :accounts

  def get_suitable_task(account)
    puts "lets get a task"
    self.tasks.all.each do |task|
      if task.break_condition == nil
        puts "bad task, move on"
      elsif task.break_condition.name == "TIME_OR_LEVEL" && task.skill != nil
        account_level = Level.where(:account => account).select {|level| level.name == task.skill}.first.level
        time = Time.now.change(:month => 1, :day => 1, :year => 2000)
        if time > task.get_start_time && time < task.get_end_time && account_level.to_i < task.break_after.to_i
          return task
          end
      elsif task.break_condition.name == "TIME"
      puts "time task"
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
        if time > task.get_start_time && time < task.get_end_time
          return task
        end
      elsif task.break_condition.name == "LEVEL" && task.skill != nil
        account_level = Level.where(:account => account).select {|level| level.name == task.skill}.first.level
        if account_level.to_i < task.break_after.to_i
          return task
        end
      end
    end
    return nil
  end

  def get_time_unil_next_task
    time_left = 1000000
    self.tasks.all.each do |task|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      puts time_left
      task_time_left = task.get_start_time - time
      puts task_time_left
      if time < task.get_start_time && task.get_start_time - time < time_left
        time_left = task.get_start_time - time
      end
    end
    return time_left
  end

  def total_time_per_day
    time = 0
    self.tasks.all.each do |task|
      time += task.get_task_duration
    end
    return time
  end
end
