class Quest < ApplicationRecord
  belongs_to :account
  has_many :tasks
end
