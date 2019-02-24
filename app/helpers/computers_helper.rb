require_relative '../functions'

module ComputersHelper

  def money_made(computer)
    accounts = Account.where(computer: computer)
    money_made = 0
    accounts.each do |acc|
      if acc.money_made != nil
        money_made += acc.money_made
      end
    end
    return money_made/1000000 * 0.7
  end

  def money_made_day(computer, day)
    day = day.new_offset(0)
    mule_logs =  MuleLog.where(created_at: day..day+1.days)
    mule_logs = mule_logs.select{|log| log.account.computer_id == computer.id}
    money_made = 0
    mule_logs.each do |log|
      money_made +=log.item_amount
    end
    return money_made
  end

end
