class Quest < ApplicationRecord
  has_many :quest_stats
  has_many :tasks
end
