class AccountsController < ApplicationController

  def index
    @available_accounts = Account.where(banned: false, created: true)

  end
  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
    @schemas = Schema.all
    @account_types = AccountType.all
    @computers = Computer.all
    @mules = Account.all.select {|acc| acc.account_type != nil && acc.account_type.name == "MULE"}
  end

  def json
    @account = Account.find(params[:id])

    render json: "{
  'Clients': [{
    'UseProxy': true,
    'ScriptArgs': '',
    'RsPassword': '#{@account.password}',
    'Config': {
      'EngineTickDelay': 0,
      'DisableModelRendering': false,
      'LowCpuMode': true,
      'DisableSceneRendering': false,
      'SuperLowCpuMode': true
    },
    'ScriptName': 'nex',
    'ProxyIp': '#{@account.proxy.ip}',
    'ProxyUser': '#{@account.proxy.username}',
    'IsRepoScript': false,
    'World': #{@account.world},
    'ProxyPort': #{@account.proxy.port},
    'RsUsername': '#{@account.login}',
    'ProxyPass': '#{@account.proxy.password}'
  }],
  'AutoUpdateClient': true
}"
  end

  def edit
    @account = Account.find(params[:id])
    @schemas = Schema.all
    @account_types = AccountType.all
    @computers = Computer.all
    @mules = Account.all.select {|acc| acc.account_type != nil && acc.account_type.name == "MULE"}
  end



  def create
    @account = Account.new(account_params)
    if params[:proxy_id] != nil
      @account.update(:proxy => Proxy.find(params[:proxy_id]))
    end
    @account.save
    redirect_to @account
  end

  def update
    @account = Account.find(params[:id])

    if @account.update(account_params)
      if params[:proxy_id] != nil
        @account.update(:proxy => Proxy.find(params[:proxy_id]))
      end
      redirect_to @account
    else
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_path
  end

  private
  def account_params
    params.require(:account).permit(:rs_world_id, :eco_system_id, :login, :password, :proxy_id, :schema_id, :world, :account_type_id, :username, :banned, :should_mule, :computer_id, :mule_id, :created)
  end
end
