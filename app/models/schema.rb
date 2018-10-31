class Schema < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :accounts

  def get_suitable_task
    self.tasks.all.each do |task|
      time = Time.now.change(:month => 1, :day => 1, :year => 2000)
      if time > task.get_start_time && time < task.get_end_time
        return task
      end
    end
    return nil
  end

  def total_time_per_day
    time = 0
    self.tasks.all.each do |task|
      time += task.get_task_duration
    end
    return time
  end
end
