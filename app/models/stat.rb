class Stat < ApplicationRecord
  belongs_to :skill
  belongs_to :account

  @@skills = nil
  def skill
    @@skills = Skill.all.to_a if @@skills == nil
    result = @@skills.select { |sk| sk.id == self.skill_id }.first
    return result
  end
end
