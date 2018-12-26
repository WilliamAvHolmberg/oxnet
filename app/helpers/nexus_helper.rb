module NexusHelper
  def hello
    return "hello"
  end

  def money_made_today
    total_money_withdrawn = 0

    @mules.each do |mule|
      total_money_withdrawn += mule.get_money_withdrawn(@mule_logs)
    end
    return total_money_withdrawn
  end

  def get_mules
    return @mules
  end



end
