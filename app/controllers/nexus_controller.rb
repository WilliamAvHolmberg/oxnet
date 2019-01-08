require_relative '../generate_account'
class NexusController < ApplicationController

  def show
    @proxies = Proxy.all
    @connected_computers = Computer.all
    @mule_logs = MuleLog.where("DATE(created_at) = ?", Date.today)
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