class NexusController < ApplicationController

  def show
    @schemas = Schema.all
    @mules = Account.select{|acc| acc.account_type.name == "MULE"}
    @proxies = Proxy.all
    @computers = Computer.all
    render 'nexus'
  end

  def create_accounts
    worlds = [404,403,402,401,400, 399, 398, 397, 377, 376, 375, 374, 373, 372, 371, 370, 369, 359, 358, 357, 356, 355,354, 353, 352, 351, 340, 339, 338, 337, 336, 335, 334 ,333, 331, 330, 326, 3325]
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