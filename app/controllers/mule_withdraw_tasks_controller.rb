class MuleWithdrawTasksController < ApplicationController
  before_action :set_mule_withdraw_task, only: [:show, :edit, :update, :destroy]

  # GET /mule_withdraw_tasks
  # GET /mule_withdraw_tasks.json
  def index
    @mule_withdraw_tasks = MuleWithdrawTask.all
  end

  # GET /mule_withdraw_tasks/1
  # GET /mule_withdraw_tasks/1.json
  def show
  end

  # GET /mule_withdraw_tasks/new
  def new
    @mule_withdraw_task = MuleWithdrawTask.new
  end

  # GET /mule_withdraw_tasks/1/edit
  def edit
  end

  # POST /mule_withdraw_tasks
  # POST /mule_withdraw_tasks.json
  def create
    @mule_withdraw_task = MuleWithdrawTask.new(mule_withdraw_task_params)

    respond_to do |format|
      if @mule_withdraw_task.save
        format.html { redirect_to @mule_withdraw_task, notice: 'Mule withdraw task was successfully created.' }
        format.json { render :show, status: :created, location: @mule_withdraw_task }
      else
        format.html { render :new }
        format.json { render json: @mule_withdraw_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mule_withdraw_tasks/1
  # PATCH/PUT /mule_withdraw_tasks/1.json
  def update
    respond_to do |format|
      if @mule_withdraw_task.update(mule_withdraw_task_params)
        format.html { redirect_to @mule_withdraw_task, notice: 'Mule withdraw task was successfully updated.' }
        format.json { render :show, status: :ok, location: @mule_withdraw_task }
      else
        format.html { render :edit }
        format.json { render json: @mule_withdraw_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mule_withdraw_tasks/1
  # DELETE /mule_withdraw_tasks/1.json
  def destroy
    @mule_withdraw_task.destroy
    respond_to do |format|
      format.html { redirect_to mule_withdraw_tasks_url, notice: 'Mule withdraw task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mule_withdraw_task
      @mule_withdraw_task = MuleWithdrawTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mule_withdraw_task_params
      params.require(:mule_withdraw_task).permit(:name, :area_id, :task_type_id, :slave_name, :item_id, :item_amount, :world, :executed, :account_id)
    end
end
