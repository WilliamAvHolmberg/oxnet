class TaskType < ApplicationRecord
  after_save :after_save
  has_many :mule_withdraw_tasks

  def after_save
    @@cache = nil
  end

  @@cache = nil
  def self.find_by_id(id)
    @@cache = self.all.to_a if @@cache == nil
    return @@cache.select { |s| s.id == id }.first
  end
  def self.find_by_name(name)
    @@cache = self.all.to_a if @@cache == nil
    return @@cache.select { |s| s.name == name }.first
  end
end
