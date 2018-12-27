module RsWorldsHelper
  def get_amount_of_players(world)
    return world.accounts.size
  end
end
