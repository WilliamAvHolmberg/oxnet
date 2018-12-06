class QuestStatsController < ApplicationController
  before_action :set_quest_stat, only: [:show, :edit, :update, :destroy]

  # GET /quest_stats
  # GET /quest_stats.json
  def index
    @quest_stats = QuestStat.all
  end

  # GET /quest_stats/1
  # GET /quest_stats/1.json
  def show
  end

  # GET /quest_stats/new
  def new
    @quest_stat = QuestStat.new
  end

  # GET /quest_stats/1/edit
  def edit
  end

  # POST /quest_stats
  # POST /quest_stats.json
  def create
    @quest_stat = QuestStat.new(quest_stat_params)

    respond_to do |format|
      if @quest_stat.save
        format.html { redirect_to @quest_stat, notice: 'Quest stat was successfully created.' }
        format.json { render :show, status: :created, location: @quest_stat }
      else
        format.html { render :new }
        format.json { render json: @quest_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quest_stats/1
  # PATCH/PUT /quest_stats/1.json
  def update
    respond_to do |format|
      if @quest_stat.update(quest_stat_params)
        format.html { redirect_to @quest_stat, notice: 'Quest stat was successfully updated.' }
        format.json { render :show, status: :ok, location: @quest_stat }
      else
        format.html { render :edit }
        format.json { render json: @quest_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quest_stats/1
  # DELETE /quest_stats/1.json
  def destroy
    @quest_stat.destroy
    respond_to do |format|
      format.html { redirect_to quest_stats_url, notice: 'Quest stat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest_stat
      @quest_stat = QuestStat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quest_stat_params
      params.require(:quest_stat).permit(:quest_id, :completed, :account_id)
    end
end
