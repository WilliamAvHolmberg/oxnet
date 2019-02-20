require_relative '../generate_account'
class NexusController < ApplicationController

  def show
    @proxies = Proxy.all
    @connected_computers = Computer.all.select{|comp|comp.is_connected}
    @mule_logs = MuleLog.where("created_at > NOW() - INTERVAL '? hours ? minutes'", Time.now.hour, Time.now.min).sort_by(&:created_at).reverse
    @mule_logs_last_2_hours = MuleLog.where("created_at > NOW() - INTERVAL '? hours'", 2).sort_by(&:created_at).reverse
    @banned_logs = Log.where("created_at > NOW() - INTERVAL '? hours' AND text LIKE '%banned%'", 20).order("created_at DESC").limit(10)
    @available_accounts = Account.where(banned: false, created: true)
    @active_accounts = @available_accounts.select{|acc| !acc.is_available}
    @mules = @available_accounts.select{|acc| acc.account_type.name == "MULE"}
    @slaves = @available_accounts.select{|acc| acc.account_type.name == "SLAVE"}
    @latest_task_logs = TaskLog.limit(5).order('id desc')


    render 'nexus'
  end

  def create_accounts
    ga = GenerateAccount.new
    computer = Computer.find(params[:computer_id])
    proxy = Proxy.find(params[:proxy_id])

    ga.create_accounts(params[:amount_of_accounts].to_i, computer, proxy)

    render plain: "nice"
  end


end