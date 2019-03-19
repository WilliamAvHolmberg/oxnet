class Stat < ApplicationRecord
  belongs_to :skill
  belongs_to :account

  def skill
    return Skill.find_by_id(self.skill_id)
  end

end
