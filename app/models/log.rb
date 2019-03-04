class Log < ApplicationRecord
  after_initialize :custom_init
  belongs_to :account, optional: true
  belongs_to :computer, optional: true


  def custom_init
    if computer != nil
      update_computer
    end
    if account != nil
      update_account
    end
  end

  def update_computer
    last_seen = computer.last_seen
    if last_seen == nil
      last_seen = Time.now
    end
    if (Time.now - last_seen) < 30
      if computer.time_online == nil then time_online = 0 else time_online = computer.time_online end
      computer.update(time_online:(Time.now - last_seen + time_online))
    end
    computer.update(last_seen: Time.now)
    computer.save
  end

  def update_account
      last_seen = account.last_seen
      if last_seen == nil
        last_seen = Time.now
      end
      if (Time.now - last_seen) < 30
        if account.time_online == nil then time_online = 0 else time_online = account.time_online end
        account.update(time_online:(Time.now - last_seen + time_online))
      end
      account.update(last_seen: Time.now.utc)
      account.save
  end
end
