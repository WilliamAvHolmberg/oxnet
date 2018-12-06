class QuestStat < ApplicationRecord
  belongs_to :quest
  belongs_to :account
end
