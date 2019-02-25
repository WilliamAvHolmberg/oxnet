class LogsController < ApplicationController
  def index

    if params[:account_id].present?
      @logs = Log.where(account_id: params[:account_id]).where("text != '[\"log\", \"0\\r\\n\"]'")
      account = Account.find(params[:account_id])
      @subtitle = "Account: " + (account.username.present? ? account.username : "UNKNOWN")
    else
      @logs = Log.where(created_at: 1.hours.ago..1.days.from_now).where("text != '[\"log\", \"0\\r\\n\"]'")
    end
  end
  def show
    @log = Log.find(params[:id])
  end

  def new
    @log = Log.new
  end

  def edit
    @log = Log.find(params[:id])
  end



  def create
    @log = Log.new(log_params)
    @log.update(:account_id => params[:account_id])
    @log.save
    redirect_to @log
  end

  def update
    @log = Log.find(params[:id])

    if @log.update(log_params)
      @log.update(:account_id => params[:account_id])
      redirect_to @log
    else
      render 'edit'
    end
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy

    redirect_to logs_path
  end

  private
  def log_params
    params.require(:log).permit(:text, :account_id)
  end
end
