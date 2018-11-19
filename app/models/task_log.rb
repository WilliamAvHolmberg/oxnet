class TaskLog < ApplicationRecord
  belongs_to :account
  belongs_to :task
end
