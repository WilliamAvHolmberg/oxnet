class Skill < ApplicationRecord
  after_initialize :after_initialize
  has_many :tasks
  has_many :stats,  dependent: :destroy

  def after_initialize
    @@cache = nil
  end

  @@cache = nil
  def self.find_by_name(name)
    @@cache = self.all.to_a if @@cache == nil
    result = @@cache.select { |s| s.name == name }.first
    return result if result != nil

    result = Skill.find_or_initialize_by(name: name)
    result.save
    @@cache = nil
    return result
  end

  def self.find_by_id(id)
    @@cache = self.all.to_a if @@cache == nil
    result = @@cache.select { |s| s.id == id }.first
    return result
  end

  def self.find_quick(name_or_id)
    return find_by_id(name_or_id) || find_by_name(name_or_id)
  end

end
