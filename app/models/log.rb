class Log < ApplicationRecord
  belongs_to :account, optional: true
end
