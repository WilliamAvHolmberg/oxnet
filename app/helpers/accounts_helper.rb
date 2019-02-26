module AccountsHelper
  def money_made_day(mule, day)
    day = day.new_offset(0)
    mule_logs =  MuleLog.where(created_at: day..day+1.days)

    return mule.get_money_withdrawn(mule_logs)
  end
end
