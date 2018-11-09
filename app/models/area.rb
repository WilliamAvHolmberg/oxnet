class Area < ApplicationRecord
  has_many :tasks
  has_many :mule_withdraw_tasks
end
