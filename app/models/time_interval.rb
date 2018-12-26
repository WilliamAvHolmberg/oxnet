class TimeInterval < ApplicationRecord
  belongs_to :schema


  def get_task_duration
    return (self.end_time - self.start_time)/60
  end

  def get_start_time
    return self.start_time - 120.minutes
  end
  def get_end_time
    return self.end_time
  end
end
