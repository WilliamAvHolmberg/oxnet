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

  def money_made_days(computer, days_ago)
    @timezone_offset = Time.zone_offset(Time.now.getlocal.zone) / 3600
    @tz_interval = (@timezone_offset >= 0 ? "+" : "-") + " interval '#{@timezone_offset} hour'"

    interval = @tz_interval
    start_date = days_ago.days.ago
    mule_logs = MuleLog.where("account_id IN (SELECT id FROM accounts WHERE account_type_id IN (SELECT id from account_types WHERE name='MULE') AND computer_id='#{computer.id}')")
                              .where('created_at IS NOT NULL')
                              .where('created_at > ?', start_date.beginning_of_day)
                              .group("DATE(created_at #{interval})", config.time_zone)
                              .select("date(created_at #{interval}) as date, SUM(item_amount) AS money_made")
                              .order("date").all

    result = {}
    mule_logs.each do |log|
      result[log.date.strftime("%a, %d %b %Y")] = log.money_made
    end

    return result
  end

end
