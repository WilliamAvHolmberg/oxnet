class Proxy < ApplicationRecord
  belongs_to :account, optional: true
end
