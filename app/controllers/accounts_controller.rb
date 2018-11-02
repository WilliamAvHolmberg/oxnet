class AccountsController < ApplicationController

  def index
    @accounts = Account.all
  end
  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
    @schemas = Schema.all
  end

  def edit
    @account = Account.find(params[:id])
    @schemas = Schema.all
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
    params.require(:account).permit(:login, :password, :proxy_id, :schema_id, :world)
  end
end
