class Schema < ApplicationRecord
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy
  has_many :accounts
  has_many :time_intervals, dependent: :destroy


  class << self
    def primary_schemas
      return Schema.where(default: false)
    end
    def ordered_by_use
      return primary_schemas
          .select("schemas.*,
(SELECT COUNT(*) FROM schemas as schB WHERE schB.disabled=false AND schB.original_id=schemas.id) as num_slaves,
(SELECT COUNT(*) FROM schemas as schB WHERE schB.disabled=true AND schB.original_id=schemas.id) as dead_slaves")
          .order('max_slaves ASC,num_slaves ASC')
    end
    def next_to_use
      results = primary_schemas
                   .select("schemas.*,
(SELECT COUNT(*) FROM schemas as schB WHERE schB.disabled=false AND schB.original_id=schemas.id) as num_slaves")
                    .sort_by{|row| (row.max_slaves - row.num_slaves) }
      results.each do |result|
        return result if (result.num_slaves < result.max_slaves)
      end
      return results.last
    end
  end


  def time_is_right
    self.time_intervals.all.each do |interval|
      time = Time.now.getutc().change(:month => 1, :day => 1, :year => 2000)
      if time > interval.get_start_time && time < interval.get_end_time
        return true
      end
      puts "#{time} not within #{interval.get_start_time} and #{interval.get_end_time}"
    end
    return false
  end

  def get_time_interval
    self.time_intervals.all.each do |interval|
      time = Time.now.getutc().change(:month => 1, :day => 1, :year => 2000)
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
      puts "#{account.username} time is right (#{tasks.count} tasks)"
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
        puts "No doable tasks for #{account.username}"
        return nil
      elsif task.task_type.name == "QUEST"
        return task
      else
        task.update(:start_time => interval.start_time)
        task.update(:end_time => interval.end_time)
        puts "#{account.username} : task shall start at computer:#{account.computer.name}"
        return task
      end
    end
    return nil
  end

  def get_available_tasks(account)
    #old_tasks = tasks.select{|t| t.should_do(account) && t.task_type.name == "QUEST"}
    #if old_tasks != nil && old_tasks.length > 0
    #  return old_tasks
    #end
    #puts "Number of tasks:" + tasks.length.to_s.to_s

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
