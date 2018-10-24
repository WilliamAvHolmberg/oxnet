class Task < ApplicationRecord
  belongs_to :bank_area, :class_name => "Area", optional: true
  belongs_to :action_area, :class_name => "Area"
  belongs_to :task_type
  belongs_to :axe, optional: true

  def self.inherited(subklass)
    self.inherit_attributes(subklass)
  end
end
