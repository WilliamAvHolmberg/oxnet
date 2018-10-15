class InstructionType < ApplicationRecord
  has_many :instructions, dependent: :destroy
end
