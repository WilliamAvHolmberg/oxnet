class RsWorld < ApplicationRecord
  has_many :accounts


  def get_amount_of_players
    return accounts.size
  end

end
