class TimeIntervalsController < ApplicationController
  before_action :set_time_interval, only: [:show, :edit, :update, :destroy]

  # GET /time_intervals
  # GET /time_intervals.json
  def index
    @time_intervals = TimeInterval.where(schema: Schema.where(default: false))
  end

  # GET /time_intervals/1
  # GET /time_intervals/1.json
  def show
  end

  # GET /time_intervals/new
  def new
    @time_interval = TimeInterval.new
    @schemas = Schema.all
  end

  # GET /time_intervals/1/edit
  def edit
    @schemas = Schema.all
  end

  # POST /time_intervals
  # POST /time_intervals.json
  def create
    @schemas = Schema.all
    @time_interval = TimeInterval.new(time_interval_params)

    respond_to do |format|
      if @time_interval.save
        format.html { redirect_to @time_interval, notice: 'Time interval was successfully created.' }
        format.json { render :show, status: :created, location: @time_interval }
      else
        format.html { render :new }
        format.json { render json: @time_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_intervals/1
  # PATCH/PUT /time_intervals/1.json
  def update
    respond_to do |format|
      if @time_interval.update(time_interval_params)
        format.html { redirect_to @time_interval, notice: 'Time interval was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_interval }
      else
        format.html { render :edit }
        format.json { render json: @time_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_intervals/1
  # DELETE /time_intervals/1.json
  def destroy
    @time_interval.destroy
    respond_to do |format|
      format.html { redirect_to time_intervals_url, notice: 'Time interval was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_interval
      @time_interval = TimeInterval.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_interval_params
      params.require(:time_interval).permit(:name, :start_time, :end_time, :schema_id)
    end
end
