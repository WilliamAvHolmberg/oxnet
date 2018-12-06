class Skill < ApplicationRecord
  has_many :tasks
  has_many :stats
end
