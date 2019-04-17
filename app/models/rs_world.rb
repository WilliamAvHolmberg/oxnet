class RsWorld < ApplicationRecord
  has_many :accounts


  def get_amount_of_players
    return accounts.where(banned:false, created: true).size
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

  @unavailable_worlds = [302, 308, 309, 310, 316, 317, 318, 325, 326, 333, 334, 341, 342, 349, 350, 358, 364, 365, 366, 371, 372, 373, 379, 380, 381, 382, 407, 408]
  def get_world
    current_world = world.chomp.to_i
    if @unavailable_worlds.contains(current_world)
      new_world = get_least_used_worlds.sample
      return new_world.number
    end
    return current_world
  end

end
