class Script < ApplicationRecord
  has_many :instructions, dependent: :destroy
end
