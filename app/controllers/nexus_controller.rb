class NexusController < ApplicationController

  def show
    @schemas = Schema.all
    @mules = Account.select{|acc| acc.account_type.name == "MULE"}
    @proxies = Proxy.all
    @computers = Computer.all
    render 'nexus'
  end

  def create_accounts
    worlds = [385,468,476,473,469,472,474,475,470,471,394,414,413,456,451,457,455,398,459,454,397,500,502,497,499,501,453]
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