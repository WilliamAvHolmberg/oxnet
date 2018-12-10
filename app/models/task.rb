class Task < ApplicationRecord
  belongs_to :bank_area, :class_name => "Area", optional: true
  belongs_to :action_area, :class_name => "Area"
  belongs_to :task_type
  belongs_to :axe, :class_name => "RsItem", optional: true
  belongs_to :food, :class_name => "RsItem", optional: true
  belongs_to :break_condition
  belongs_to :schema, optional:true
  belongs_to :inventory, optional:true
  belongs_to :gear, optional:true
  belongs_to :quest
  belongs_to :skill
  has_many :task_logs, dependent: :destroy
  has_many :requirements

  accepts_nested_attributes_for :requirements

  acts_as_list :scope => :schema

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

  def should_do(account)
    return can_undertake(account) && !is_completed(account)
  end
  def can_undertake(account)
    if requirements.length == 0
      return true
    end

    requirements.each do |req|
      account_level = account.stats.find_by(skill: req.skill)
      if account_level == nil
        return true
      end
      account_level = account_level.level.to_i
      if account_level < req.level.to_i
        return false
      end
    end
    return true
  end

  def is_completed(account)
    if task_type.name == "QUEST" && quest != nil
      if account.quest_stats.find_by(quest: quest) == nil
        return false
      elsif account.quest_stats.find_by(quest: quest).completed
        return true
      end
    else
      if account.stats.find_by(skill: skill) == nil
        return false
      end
      if break_after.to_i <= account.stats.find_by(skill: skill).level.to_i
        return true
      end
    end
    return false
  end
end
