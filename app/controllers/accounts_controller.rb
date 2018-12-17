class AccountsController < ApplicationController

  def index
    @available_accounts = Account.where(banned: false, created: true)
    @banned_accounts = Account.where(banned: true)

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

    render json: '{
  "Clients": [{
    "UseProxy": false,
    "ScriptArgs": "",
    "RsPassword": "Lifepeerbook123",
    "Config": {
      "EngineTickDelay": 0,
      "DisableModelRendering": false,
      "LowCpuMode": true,
      "DisableSceneRendering": false,
      "SuperLowCpuMode": true
    },
    "ScriptName": "nex",
    "ProxyIp": "",
    "ProxyUser": "",
    "IsRepoScript": false,
    "World": 301,
    "ProxyPort": 0,
    "RsUsername": "william",
    "ProxyPass": ""
  }],
  "AutoUpdateClient": true
}'
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
    params.require(:account).permit(:login, :password, :proxy_id, :schema_id, :world, :account_type_id, :username, :banned, :should_mule, :computer_id, :mule_id, :created)
  end
end
