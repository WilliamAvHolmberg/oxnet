require_relative '../functions'

class AccountsController < ApplicationController

  def index
    @available_accounts = Account.includes(:mule, :proxy, :schema, {:schema => :time_intervals}, :account_type, :eco_system, :stats, :computer)
                              .where(banned: false, created: true).sort_by{|acc|acc.get_total_level}.reverse

    @schemas = Schema.where(default: false).all.to_a
    @available_accounts.each do |acc|
      if acc.password.include? "\n"
        acc.update(password: acc.password.strip)
      end
    end

    if params[:launch].present?
      Account.launch_accounts(0)
      redirect_to accounts_path
    end
    if params[:delete_locked].present?
      changes_made = Account.where(created:true, locked: true, banned: false).update_all(banned:true)
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: "#{changes_made} Accounts were banned." }
      end
      # redirect_to accounts_path
    end
  end

  def show
    @account = Account.find(params[:id])
    @tasks = @account.schema.tasks if !@account.schema.nil?

    @isOnline = !@account.is_available
    @launchTitle = ""
    if @isOnline
      #do nothing
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
          Instruction.new(:instruction_type_id => InstructionType.find_by_name("NEW_CLIENT").id, :computer_id => computer.id, :account_id => @account.id, :script_id => Script.first.id).save
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
    'UseProxy': true,
    'ScriptArgs': '',
    'RsUsername': '#{@account.login}',
    'RsPassword': '#{@account.password}',
    'Config': {
      'EngineTickDelay': 10,
      'DisableModelRendering': true,
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
    'ProxyPass': '#{@account.proxy.password}'
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
    account = Account.find(params[:id])
    account.update(banned: true)
    if account.schema.default = true #remember default is inverted...
      account.schema.update(disabled: true)
    end

    # render json: JSON.pretty_generate(params.as_json)
    # render plain: "Tried to ban #{params[:id]}"
    redirect_to accounts_path
  end
  def disconnect
    account = Account.find(params[:id])

    ins = Instruction.new(:instruction_type_id => InstructionType.find_by_name("DISCONNECT").id, :computer_id => account.computer_id, :account_id => account.id, :script_id => nil)
    ins.save

    render json: { success: true }.to_json
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_path
  end

  def get_player_positions
    online_players = Account.all_accounts_online.select(:id, :username, :world, :created_at, :computer_id).includes(:computer).to_a
    task_logs = TaskLog.includes(:task).select("DISTINCT ON (account_id) *").where(:created_at => (Time.now.utc - 20.minutes..Time.now.utc), account_id: online_players.pluck(:id)).where.not(position: nil).order("account_id, created_at DESC").to_a
    # tasks = Task.select(:id, :name).where(id: task_logs.pluck(:task_id)).to_a

    data = []
    task_logs.each do |task_log|
      next if task_log.position == nil
      position = task_log.position.split(';')
      next if position.length < 4
      account_id = task_log.account_id #cache this dictionary value
      # task_id = task_log.task_id #cache this dictionary value
      account = online_players.select { |a| a.id == account_id }.first
      next if account == nil
      task = task_log.task # tasks.select { |t| t.id == task_id }.first
      task_name = task.name if task != nil
      task_name = task_name.partition("---").last if task_name != nil && task_name.include?("---")
      age = formatted_duration(Time.now.utc - account.created_at)
      computer = account.computer.name
      data << [position[1].to_i, position[2].to_i, account_id.to_s, account.username, task_name, account.world, age, computer]
    end

    render json: data.to_json
  end

  private
  def account_params
    params.require(:account).permit(:rs_world_id, :eco_system_id, :login, :password, :proxy_id, :schema_id, :world, :account_type_id, :username, :banned, :should_mule, :computer_id, :mule_id, :created, :locked)
  end
end
