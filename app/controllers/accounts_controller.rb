class AccountsController < ApplicationController

  def index
    @available_accounts = Account.includes(:mule, :proxy, :schema, :account_type, :eco_system, :stats).where(banned: false, created: true).sort_by{|acc|acc.get_total_level}.reverse

    @available_accounts.each do |acc|
      if acc.password.include? "\n"
        acc.update(password: acc.password.strip)
      end
    end

  end
  def show
    @account = Account.find(params[:id])
    @tasks = @account.schema.tasks if !@account.schema.nil?

    @isOnline = !@account.is_available
    @launchTitle = ""
    if @isOnline

    elsif params[:launched].present?
      @launchTitle = "LAUNCHED!"
    else
      computer = @account.computer if @account.computer_id != nil
      @readyToLaunch = false
      if computer != nil && computer.is_available_to_nexus && computer.can_connect_more_accounts
        @readyToLaunch = true
        @launchTitle = "LAUNCH"
        if params[:launch].present?
          @launchTitle = "LAUNCHED!"
          Instruction.new(:instruction_type_id => InstructionType.first.id, :computer_id => computer.id, :account_id => @account.id, :script_id => Script.first.id).save
          Log.new(computer_id: computer.id, account_id: @account.id, text: "Instruction created")
          redirect_to @account
        end
      end
    end

  end

  def new
    @account = Account.new
    @schemas = Schema.all
    @account_types = AccountType.all
    @computers = Computer.all
    @mules = Account.all.select {|acc| acc.account_type != nil && acc.account_type.name == "MULE"}
  end

  def json
    @account = Account.includes(:proxy).find(params[:id])
    port = @account.proxy.port
    if port.blank?
      port = 0
    end
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
    'ProxyPort': #{port},
    'RsUsername': '#{@account.login}',
    'ProxyPass': '#{@account.proxy.password}'
  }],
  'AutoUpdateClient': true
}"
  end

  def edit
    @account = Account.find(params[:id])
    @schemas = Schema.where(default: false).or(Schema.where(id: @account.schema_id))

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

  def ban
    @account = Account.find(params[:id])
    @account.update(banned: true)

    redirect_to accounts_path
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_path
  end

  private
  def account_params
    params.require(:account).permit(:rs_world_id, :eco_system_id, :login, :password, :proxy_id, :schema_id, :world, :account_type_id, :username, :banned, :should_mule, :computer_id, :mule_id, :created, :locked)
  end
end
