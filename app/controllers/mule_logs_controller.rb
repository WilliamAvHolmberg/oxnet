class MuleLogsController < ApplicationController
  before_action :set_mule_log, only: [:show, :edit, :update, :destroy]

  # GET /mule_logs
  # GET /mule_logs.json
  def index
    @mule_logs = MuleLog.all
  end

  # GET /mule_logs/1
  # GET /mule_logs/1.json
  def show
  end

  # GET /mule_logs/new
  def new
    @mule_log = MuleLog.new
  end

  # GET /mule_logs/1/edit
  def edit
  end

  # POST /mule_logs
  # POST /mule_logs.json
  def create
    @mule_log = MuleLog.new(mule_log_params)

    respond_to do |format|
      if @mule_log.save
        format.html { redirect_to @mule_log, notice: 'Mule log was successfully created.' }
        format.json { render :show, status: :created, location: @mule_log }
      else
        format.html { render :new }
        format.json { render json: @mule_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mule_logs/1
  # PATCH/PUT /mule_logs/1.json
  def update
    respond_to do |format|
      if @mule_log.update(mule_log_params)
        format.html { redirect_to @mule_log, notice: 'Mule log was successfully updated.' }
        format.json { render :show, status: :ok, location: @mule_log }
      else
        format.html { render :edit }
        format.json { render json: @mule_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mule_logs/1
  # DELETE /mule_logs/1.json
  def destroy
    @mule_log.destroy
    respond_to do |format|
      format.html { redirect_to mule_logs_url, notice: 'Mule log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mule_log
      @mule_log = MuleLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mule_log_params
      params.require(:mule_log).permit(:account_id, :item_amount, :mule)
    end
end
