class RsWorld < ApplicationRecord
  has_many :accounts


  def get_amount_of_players
    return accounts.where(banned:false, created: true).size
  end

end
