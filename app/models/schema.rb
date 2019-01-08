class Schema < ApplicationRecord
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy
  has_many :accounts
  has_many :time_intervals, dependent: :destroy





  def time_is_right
    self.time_intervals.all.each do |interval|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      if time > interval.get_start_time && time < interval.get_end_time
        return true
      end
    end
    return false
  end

  def get_time_interval
    self.time_intervals.all.each do |interval|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      if time > interval.get_start_time && time < interval.get_end_time
        return interval
      end
    end
    return nil
  end

  def get_suitable_task(account)
    if time_is_right == false
      return nil
    else
      puts "#{account.username} time is right"
      interval = get_time_interval
      task = tasks.select{|t| t.should_do(account) && t.task_type.name == "QUEST"}.first
      if task != nil
        task.update(:start_time => interval.start_time)
        task.update(:end_time => interval.end_time)
        puts "#{account.username} : quest task shall start"
        return task
      end
      task = tasks.select{|t| t.should_do(account)}.first
      if task == nil
        puts "nil: for #{account.username}"
        return nil
      elsif task.task_type.name == "QUEST"
        return task
      else
        task.update(:start_time => interval.start_time)
        task.update(:end_time => interval.end_time)
        puts "#{account.username} : task shall start"
        return task
      end
    end
    return nil
  end

  def get_available_tasks(account)
    old_tasks = tasks.select{|t| t.should_do(account) && t.task_type.name == "QUEST"}
    if old_tasks != nil && old_tasks.length > 0
      return old_tasks
    end

    old_tasks = tasks.select{|t| t.should_do(account)}
    if old_tasks != nil && old_tasks.length > 0
      return old_tasks
    end

    return nil
  end

  def get_time_unil_next_task
    time_left = 1000000
    self.tasks.all.each do |task|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      if time < task.get_start_time && task.get_start_time - time < time_left
        time_left = task.get_start_time - time
      end
    end
    return time_left
  end

  def total_time_per_day
    time = 0
    self.time_intervals.all.each do |task|
      time += task.get_task_duration
    end
    return time
  end
end
