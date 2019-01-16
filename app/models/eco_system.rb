class EcoSystem < ApplicationRecord
  has_many :proxies
  has_many :accounts
  has_many :computers
end
