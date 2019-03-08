module NexusHelper
  def hello
    return "hello"
  end

  def get_master_mule_account_type
    return AccountType.where(:name => "MASTER_MULE").first
  end
  def get_master_mules
    account_type = get_master_mule_account_type
    return Account.where(account_type_id: account_type.id, banned: false)
  end
  def is_master_mule_log (master_mules, log)
    if master_mules.size > 0
      return true if log.account.account_type_id == master_mules.first.account_type_id
      return true if master_mules.any? {|mm| mm.username == log.mule }
    end
    return false
  end

  def money_made_today
    total_money_withdrawn = 0

    master_mules = get_master_mules.all.to_a

    #Real truth profits
    @mule_logs.each do |log|
      next if is_master_mule_log(master_mules, log)
      if log.account.account_type.name == "MULE"
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

    master_mules = get_master_mules.all.to_a

    #Real truth profits
    @mule_logs_last_2_hours.each do |log|
      next if is_master_mule_log(master_mules, log)
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
