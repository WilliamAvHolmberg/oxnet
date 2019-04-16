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
  has_many :requirements, dependent: :destroy

  accepts_nested_attributes_for :requirements, allow_destroy: true

  acts_as_list :scope => :schema


  def self.search(search)
    if search
      where('UPPER(created_at) LIKE ?', "%#{search.upcase}%")
    else
      nil
    end
  end
  def self.inherited(subklass)
    self.inherit_attributes(subklass)
  end

  def task_type
    return TaskType.find_by_id(task_type_id)
  end

  def get_task_duration
    return (self.end_time - self.start_time)/60
  end

  def get_duration_left
    return ((get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
  end

  def get_parsed_duration
    if break_condition == "TIME"
      task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
      level_goal = "99"
    elsif break_condition == "LEVEL" && task.break_after != nil
      task_duration = "999999"
      level_goal = task.break_after
    elsif break_condition == "TIME_OR_LEVEL"
      task_duration = ((task.get_end_time - Time.now.change(:month => 1, :day => 1, :year => 2000))/60).round
      level_goal = task.break_after
      puts task_duration
    end
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
    #puts "#{id} has #{requirements.length} requirements"
    if requirements.size == 0
      return true
    end
    requirements.each do |req|
      account_level = account.stats_find(req.skill_id)
      if account_level == nil
        return true
      end
      account_level = account_level.level.to_i
      if(account_level <= 1)
        account_level = 1;
      end
      if account_level < req.level.to_i
        #puts "Too low level #{account_level} < #{req.level}"
        return false
      end
    end
    return true
  end

  def break_condition_to_json
      break_name = break_condition.name
      if break_name == "TIME"
        task_duration = get_duration_left
        level_goal = "99"
      elsif break_name == "LEVEL" && break_after != nil
        task_duration = "999999"
        level_goal = break_after
      elsif break_name == "TIME_OR_LEVEL"
        task_duration = get_duration_left
        level_goal = break_after
      end
      json_break = {
          type:break_name,
          task_duration: task_duration,
          level_goal: level_goal
      }
      return json_break
  end

  def is_completed(account)
    if task_type.name == "QUEST" && quest_id != nil
      qp = account.stats_find("QP")
      return true if qp != nil && qp.level >= 7
      quest = account.quests_find(quest_id)
      return false if quest == nil
      return true if quest.completed
    else
      skill = account.stats_find(skill_id)
      return false if skill == nil
      level = skill.level.to_i
      if break_after.to_i <= level
        #puts "#{account.username} is above level #{break_after.to_i} with #{level}"
        return true
      end
    end
    return false
  end
end
