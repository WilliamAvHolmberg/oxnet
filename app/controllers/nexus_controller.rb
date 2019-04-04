require_relative '../generate_account'
class NexusController < ApplicationController

  def show
    @proxies = Proxy.all
    @connected_computers = Computer.all.select{|comp|comp.is_connected}
    @available_accounts = Account.all_available_accounts
    @active_accounts = @available_accounts.select{|acc| !acc.is_available}
    @mules = @available_accounts.select{|acc| acc.account_type.name.include? "MULE"}
    @slaves = @available_accounts.select{|acc| acc.account_type.name == "SLAVE"}
    @new_accounts = Account.includes(:stats).where("created_at > NOW() - INTERVAL '? hours' AND created", 1).order("created_at DESC").limit(10)
    @recently_banned = Account.includes(:stats, :computer).where(banned: true, created: true).where("last_seen > NOW() - INTERVAL '2 days'").order("last_seen DESC").limit(10).to_a
    @mule_logs = MuleLog.includes(:account).where("created_at > NOW() - INTERVAL '? hours ? minutes'", Time.now.hour, Time.now.min).sort_by(&:created_at).reverse
    @mule_logs_last_2_hours = MuleLog.includes(:account).where("created_at > NOW() - INTERVAL '? hours'", 2).reverse
    @mule_logs_last_24_hours = MuleLog.includes(:account).where("created_at > NOW() - INTERVAL '? hours'", 24).reverse
    @latest_task_logs = TaskLog.includes(:task, :account).limit(5).order('id desc').to_a

    task_logs = TaskLog
                    .includes(:task)
                    .select("DISTINCT ON (account_id) *")
                    .where.not(position: nil)
                    .where(:created_at => (Time.now.utc - 20.minutes..Time.now.utc), account_id: Account.all_available_accounts)
                    .order("account_id, created_at DESC")
                    .to_a
    @areas = {}
    task_logs.each do |log|
      cur_money = log.money_per_hour.to_i
      area = Area.find_by_id(log.task.action_area_id) if log.task != nil

      if area != nil
        @areas[area.name] = {money: 0, users: 0} if @areas[area.name] == nil
        if cur_money != nil then @areas[area.name][:money] += cur_money else @areas[area.name][:money] += 0 end
        @areas[area.name][:users] += 1
      end
    end
    @areas = @areas.sort

    @name_to_id = {}
    @available_accounts.each do |acc|
      @name_to_id[acc.username.downcase] = acc.id
    end
    @master_mule_ids = {}
    @mule_ids = {}
    @mules.each do |acc|
        if acc.account_type.name == "MASTER_MULE"
          @master_mule_ids[acc.id] = acc
        else
          @mule_ids[acc.id] = acc
        end
    end

    render 'nexus'
  end

  def create_accounts
    ga = GenerateAccount.new
    computer = Computer.find(params[:computer_id])
    proxy = Proxy.find(params[:proxy_id])

    ga.create_accounts(params[:amount_of_accounts].to_i, computer, proxy)

    render plain: "nice"
  end

  def load_new_bans
    return if params[:since] == nil
    since = params[:since]
    begin
      Date.parse(since)
    rescue ArgumentError
      return
    end
    @banned_logs = Log.includes(:account).where("created_at > '?' AND text LIKE '%banned%'", since).order("created_at DESC").limit(10)

    respond_to do |format|
      format.html{redirect_to root_url}
      format.js
    end
  end


end
