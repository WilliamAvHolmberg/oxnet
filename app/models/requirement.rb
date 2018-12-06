class Requirement < ApplicationRecord
  belongs_to :skill
  belongs_to :task
end
