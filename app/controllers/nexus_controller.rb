require_relative '../generate_account'
class NexusController < ApplicationController

  def view

    slaves = Account.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day)

    mule_logs = MuleLog.where(account: slaves)



    render 'mule_connections'
  end
  def dashboard
    @available_accounts = Account.all_available_accounts.eager_load(:account_type)
    @active_accounts = @available_accounts.select{|acc| !acc.is_available}
    @active_slaves = @available_accounts.select{|acc| acc.account_type.name == "SLAVE"}

    response = {
        'available_accounts': @available_accounts,
        'active_slaves': @active_slaves
    }
    render json: response
  end
  def index
    @proxies = Proxy.all
    @connected_computers = Computer.all.order(:id).select{|comp|comp.is_connected}
    @available_accounts = Account.all_available_accounts.eager_load(:account_type)
    @active_accounts = @available_accounts.select{|acc| !acc.is_available}
    collect_mules
    @slaves = @available_accounts.select{|acc| acc.account_type.name == "SLAVE"}
    @schemas = Schema.where(default: false).to_a
    @new_accounts = Account.includes(:stats, :schema).where("accounts.created_at > NOW() - INTERVAL '? hours' AND created", 2).order("accounts.created_at DESC").limit(30)
    @failed_accounts = Account.includes(:stats).where("created_at > NOW() - INTERVAL '? hours' AND NOT created", 1).order("created_at DESC").limit(30)

    @recently_banned = Account.includes(:stats, :computer).where(banned: true, created: true).where("accounts.last_seen > NOW() - INTERVAL '1 days'").order("accounts.last_seen DESC").limit(10).to_a
    @mule_logs = MuleLog.includes(:account).where("mule_logs.created_at > NOW() - INTERVAL '? hours ? minutes'", Time.now.hour, Time.now.min).to_a.sort_by(&:created_at).reverse
    # @mule_logs_last_2_hours = MuleLog.includes(:account).where("mule_logs.created_at > NOW() - INTERVAL '? hours'", 2).to_a.reverse
    @mule_logs_last_24_hours = MuleLog.includes(:account).where("mule_logs.created_at > NOW() - INTERVAL '? hours'", 24).to_a.reverse
    @latest_task_logs = TaskLog.includes(:task, :account).limit(5).order('task_logs.id desc').to_a

    @areas = {}
    task_logs = TaskLog
                    .includes(:task)
                    .select("DISTINCT ON (task_logs.account_id) *")
                    .where.not(position: nil)
                    .where(:created_at => (Time.now.utc - 20.minutes..Time.now.utc))
                    .where(account_id: @active_accounts.pluck(:id))
                    .order("task_logs.account_id, task_logs.created_at DESC")
                    .to_a
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

    render 'nexus'
  end

  def collect_mules
    @name_to_id = {}
    @available_accounts.each do |acc|
      @name_to_id[acc.username.downcase] = acc.id
    end

    @mules = @available_accounts.select{|acc| acc.account_type.name.include? "MULE"}
    @master_mule_ids = {}
    @mule_ids = {}
    @mules.each do |acc|
      if acc.account_type.name == "MASTER_MULE"
        @master_mule_ids[acc.id] = acc
      else
        @mule_ids[acc.id] = acc
      end
    end
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

  def update_mule_logs
    return if params[:since] == nil
    since = params[:since].to_s
    since = since.to_time
    since += 1.seconds

    @mule_logs = MuleLog.includes(:account).where("mule_logs.created_at > ?", since).limit(200).to_a.sort_by(&:created_at).reverse
    if(@mule_logs.size == 0)
      render plain:""
      return
    end
    @available_accounts = Account.all_available_accounts.eager_load(:account_type)
    # @mule_logs_last_2_hours = MuleLog.includes(:account).where("mule_logs.created_at > NOW() - INTERVAL '? hours'", 2).to_a.reverse
    @mule_logs_last_24_hours = MuleLog.includes(:account).where("mule_logs.created_at > NOW() - INTERVAL '? hours'", 24).to_a.reverse
    collect_mules

    render partial:'update_mule_logs'
  end

  def number_with_delimiter(number, options)
    return helpers.number_with_delimiter(number, options)
  end

end
