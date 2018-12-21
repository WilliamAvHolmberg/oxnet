class NexusController < ApplicationController

  def show
    @mule_logs = MuleLog.all.select{|log| log.created_at.day == Time.now.day}
    @active_accounts = Account.where(banned: false, created: true).select{|acc| !acc.is_available}
    render 'nexus'
  end

  def create_accounts
    worlds = [397,398,399,425,426,430,431,433,434,435,437,438,439,440,451,452,453,454,455,456,457,458,459,469,470,471,472,473,474,475]
    password = params[:password]
    schema = Schema.find(params[:schema_id])
    mule = Account.find(params[:mule_id])
    computer = Computer.find(params[:computer_id])
    proxy = Proxy.find(params[:proxy_id])
    puts "Proxy. #{proxy.location}"
    puts "proxy. #{proxy.ip}"
    puts "picked proxy: #{params[:proxy_id]}"
    i = 1
    params[:amount_of_accounts].to_i.times do
      email = "#{i}#{params[:email]}"
      username = "#{params[:username]}#{i}"
      account = Account.new(:login => email, :password => password, :username => username, :world => worlds.sample,
                            :computer => computer, :account_type => AccountType.where(:name => "SLAVE").first,:mule => mule,
                            :schema => schema, :proxy => Proxy.find(params[:proxy_id]), :should_mule => true, :created => false)
      puts proxy.location

      account.save
      if params[:start_accounts] != nil
        ins = Instruction.new(:instruction_type_id => InstructionType.select{|ins| ins.name == "CREATE_ACCOUNT"}.first.id, :computer_id => computer.id, :account_id => account.id, :script_id => Script.first.id)
        ins.save
      end
      i+=1
    end

    render plain: "nice"
  end


end