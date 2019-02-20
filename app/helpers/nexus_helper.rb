module NexusHelper
  def hello
    return "hello"
  end

  def money_made_today
    total_money_withdrawn = 0

    #Real truth profits
    @mule_logs.each do |log|
      if (log.account.account_type.name == "MULE")
        total_money_withdrawn -= log.item_amount
      else
        total_money_withdrawn += log.item_amount
      end
    end
    # @mules.each do |mule|
    #   total_money_withdrawn += mule.get_money_withdrawn(@mule_logs)
    # end
    return total_money_withdrawn
  end
  def money_last_2_hours
    total_money_withdrawn = 0

    #Real truth profits
    @mule_logs_last_2_hours.each do |log|
      if (log.account.account_type.name == "MULE")
        total_money_withdrawn -= log.item_amount
      else
        total_money_withdrawn += log.item_amount
      end
    end
    # @mules.each do |mule|
    #   total_money_withdrawn += mule.get_money_withdrawn(@mule_logs_last_2_hours)
    # end
    return total_money_withdrawn
  end

  def get_mules
    return @mules
  end



end
