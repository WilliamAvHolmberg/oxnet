class Schema < ApplicationRecord
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy
  has_many :accounts
  has_many :time_intervals





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
      interval = get_time_interval
      task = tasks.select{|t| t.should_do(account)}.sample
      if task == nil
        puts "No task available"
        return nil
      elsif task.task_type.name == "QUEST"
        return task
      else
        task.update(:start_time => interval.start_time)
        task.update(:end_time => interval.end_time)
        return task
      end
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
