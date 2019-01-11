class HiscoresController < ApplicationController
  before_action :set_hiscore, only: [:show, :edit, :update, :destroy]

  # GET /hiscores
  # GET /hiscores.json
  def index
    @hiscores = Hiscore.all
  end

  # GET /hiscores/1
  # GET /hiscores/1.json
  def show
    @accounts = Account.where(created: true, banned:false).select{|acc| acc.stats != nil && acc.stats.where(skill: @hiscore.skill).first != nil }.sort_by{|acc| acc.stats.where(skill: @hiscore.skill).first.level}.reverse
  end

  # GET /hiscores/new
  def new
    @hiscore = Hiscore.new
  end

  # GET /hiscores/1/edit
  def edit
  end

  # POST /hiscores
  # POST /hiscores.json
  def create
    @hiscore = Hiscore.new(hiscore_params)

    respond_to do |format|
      if @hiscore.save
        format.html { redirect_to @hiscore, notice: 'Hiscore was successfully created.' }
        format.json { render :show, status: :created, location: @hiscore }
      else
        format.html { render :new }
        format.json { render json: @hiscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hiscores/1
  # PATCH/PUT /hiscores/1.json
  def update
    respond_to do |format|
      if @hiscore.update(hiscore_params)
        format.html { redirect_to @hiscore, notice: 'Hiscore was successfully updated.' }
        format.json { render :show, status: :ok, location: @hiscore }
      else
        format.html { render :edit }
        format.json { render json: @hiscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hiscores/1
  # DELETE /hiscores/1.json
  def destroy
    @hiscore.destroy
    respond_to do |format|
      format.html { redirect_to hiscores_url, notice: 'Hiscore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hiscore
      @hiscore = Hiscore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hiscore_params
      params.require(:hiscore).permit(:skill_id)
    end
end
