class ProxiesController < ApplicationController
  def index
    @proxies = Proxy.all.order(:id)

    @proxy_users = Account.where(banned: false, created: true).group('proxy_id')
                                                                    .order("proxy_id")
                                                                    .select("proxy_id, COUNT(*) as count")
  end
  def show
    @proxy = Proxy.find(params[:id])
  end

  def new
    @proxy = Proxy.new
  end

  def edit
    @proxy = Proxy.find(params[:id])
  end

  def import
    if (params[:proxies] != nil)
      custom_cooldown = params[:custom_cooldown]
      max_slaves = params[:max_slaves]
      location = params[:location]
      count = 0
      auto_assign = params[:auto_assign]
      eco_system = EcoSystem.all.first
      proxy_text = params[:proxies].gsub "\r", ""
      proxy_text.split("\n").each do |proxy_line|
        count += 1
        parts = proxy_line.strip.split(':')
        next if parts.length < 2
        ip = parts[0]
        port = parts[1]
        username = parts[2].nil? ? "" : parts[2]
        password = parts[3].nil? ? "" : parts[3]
        proxy = Proxy.new(location: "#{location} - #{count}",
                          ip: ip,
                          port: port,
                          username: username,
                          password: password,
                          custom_cooldown: custom_cooldown,
                          eco_system: eco_system,
                          auto_assign: auto_assign,
                          max_slaves: max_slaves
        )
        proxy.save
      end
      redirect_to proxies_path
    end
  end


  def json
    @proxy = Proxy.find(params[:id])
    host = @proxy.ip
    port = @proxy.port
    username = @proxy.username
    password = @proxy.password
    if port.blank?
      port = 0
    end
    render json: "{
  \"state\":1,
  \"proxySettings\": {
    \"type\":\"socks\",
    \"host\":\"#{host}\",
    \"port\":\"#{port}\",
    \"username\":\"#{username}\",
    \"password\":\"#{password}\",
    \"proxyDNS\":false
  }
}"
  end



  def create
    @proxy = Proxy.new(proxy_params)
    @proxy.update(:account_id => params[:account_id])
    @proxy.save
    redirect_to @proxy
  end

  def update
    @proxy = Proxy.find(params[:id])

    if @proxy.update(proxy_params)
      @proxy.update(:account_id => params[:account_id])
      redirect_to @proxy
    else
      render 'edit'
    end
  end

  def destroy
    replacement = Proxy.all.sample
    Account.where('banned=false AND created=true').where(proxy_id: params[:id]).update_all(proxy_id: replacement.id)
    Account.where(proxy_id: params[:id]).update_all(proxy_id: nil)
    @proxy = Proxy.find(params[:id])
    @proxy.destroy

    redirect_to proxies_path
  end

  private
  def proxy_params
    params.require(:proxy).permit(:location, :ip, :username, :password, :account_id, :port, :eco_system_id, :custom_cooldown, :auto_assign, :max_slaves)
  end
end
