class BreakConditionsController < ApplicationController
  before_action :set_break_condition, only: [:show, :edit, :update, :destroy]

  # GET /break_conditions
  # GET /break_conditions.json
  def index
    @break_conditions = BreakCondition.all
  end

  # GET /break_conditions/1
  # GET /break_conditions/1.json
  def show
  end

  # GET /break_conditions/new
  def new
    @break_condition = BreakCondition.new
  end

  # GET /break_conditions/1/edit
  def edit
  end

  # POST /break_conditions
  # POST /break_conditions.json
  def create
    @break_condition = BreakCondition.new(break_condition_params)

    respond_to do |format|
      if @break_condition.save
        format.html { redirect_to @break_condition, notice: 'Break condition was successfully created.' }
        format.json { render :show, status: :created, location: @break_condition }
      else
        format.html { render :new }
        format.json { render json: @break_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /break_conditions/1
  # PATCH/PUT /break_conditions/1.json
  def update
    respond_to do |format|
      if @break_condition.update(break_condition_params)
        format.html { redirect_to @break_condition, notice: 'Break condition was successfully updated.' }
        format.json { render :show, status: :ok, location: @break_condition }
      else
        format.html { render :edit }
        format.json { render json: @break_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /break_conditions/1
  # DELETE /break_conditions/1.json
  def destroy
    @break_condition.destroy
    respond_to do |format|
      format.html { redirect_to break_conditions_url, notice: 'Break condition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_break_condition
      @break_condition = BreakCondition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def break_condition_params
      params.require(:break_condition).permit(:name)
    end
end
