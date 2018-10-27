class Task < ApplicationRecord
  belongs_to :bank_area, :class_name => "Area", optional: true
  belongs_to :action_area, :class_name => "Area"
  belongs_to :task_type
  belongs_to :axe, :class_name => "RsItem", optional: true
  belongs_to :break_condition
  belongs_to :schema, optional:true

  def self.inherited(subklass)
    self.inherit_attributes(subklass)
  end

  def get_task_duration
    return (self.end_time - self.start_time)/60
  end

  def get_start_time
    return self.start_time - 3600
  end
  def get_end_time
    return self.end_time - 3600
  end
end
