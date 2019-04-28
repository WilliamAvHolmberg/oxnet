class RsWorld < ApplicationRecord
  has_many :accounts


  def get_amount_of_players
    return accounts.where(banned:false, created: true).size
  end
  def get_amount_of_online_players
    return accounts.where(banned:false, created: true, last_seen: (Time.now.utc - 1.minutes..Time.now.utc)).size
  end
  def get_least_used_worlds
    rs_worlds = RsWorld.where(members_only: false)
    worlds = Array.new
    current_lowest = 10000
    rs_worlds.each do |world|
      player_amount = world.get_amount_of_players
      if @unavailable_worlds.contains(world.number.chomp.to_i)
        puts "bad world"
      elsif player_amount < current_lowest
        worlds.clear
        worlds.push(world)
        current_lowest = player_amount
      elsif player_amount == current_lowest
        worlds.push(world)
      end
    end
    return worlds
  end



end
