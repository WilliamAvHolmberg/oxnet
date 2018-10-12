class Log < ApplicationRecord
  belongs_to :account, optional: true
  belongs_to :computer, optional: true
end
