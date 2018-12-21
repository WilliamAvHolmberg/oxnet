require_relative '../generate_account'
class NexusController < ApplicationController

  def show
    @proxies = Proxy.all
    @computers = Computer.all
    @mule_logs = MuleLog.where("DATE(created_at) = ?", Date.today)
    @active_accounts = Account.where(banned: false, created: true).select{|acc| !acc.is_available}
    @money_made_today = 0
    @latest_task_logs = TaskLog.limit(5).order('id desc')
    @mule_logs.each do |a|
      @money_made_today+=a.item_amount.to_i
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


end