class ProxiesController < ApplicationController
  def index
    @proxies = Proxy.all
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
