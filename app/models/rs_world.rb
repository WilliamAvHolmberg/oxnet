class RsWorld < ApplicationRecord
  has_many :accounts


  def get_amount_of_players
    return accounts.where(banned:false, created: true).size
  end
  def get_amount_of_online_players
    return accounts.where(banned:false, created: true, last_seen: (Time.now.utc - 1.minutes..Time.now.utc)).size
  end

end
