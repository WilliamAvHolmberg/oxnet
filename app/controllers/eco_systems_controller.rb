class EcoSystemsController < ApplicationController
  before_action :set_eco_system, only: [:show, :edit, :update, :destroy]

  # GET /eco_systems
  # GET /eco_systems.json
  def index
    @eco_systems = EcoSystem.all
  end

  # GET /eco_systems/1
  # GET /eco_systems/1.json
  def show
  end

  # GET /eco_systems/new
  def new
    @eco_system = EcoSystem.new
  end

  # GET /eco_systems/1/edit
  def edit
  end

  # POST /eco_systems
  # POST /eco_systems.json
  def create
    @eco_system = EcoSystem.new(eco_system_params)

    respond_to do |format|
      if @eco_system.save
        format.html { redirect_to @eco_system, notice: 'Eco system was successfully created.' }
        format.json { render :show, status: :created, location: @eco_system }
      else
        format.html { render :new }
        format.json { render json: @eco_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eco_systems/1
  # PATCH/PUT /eco_systems/1.json
  def update
    respond_to do |format|
      if @eco_system.update(eco_system_params)
        format.html { redirect_to @eco_system, notice: 'Eco system was successfully updated.' }
        format.json { render :show, status: :ok, location: @eco_system }
      else
        format.html { render :edit }
        format.json { render json: @eco_system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eco_systems/1
  # DELETE /eco_systems/1.json
  def destroy
    @eco_system.destroy
    respond_to do |format|
      format.html { redirect_to eco_systems_url, notice: 'Eco system was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eco_system
      @eco_system = EcoSystem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eco_system_params
      params.require(:eco_system).permit(:accounts, :computers, :proxies, :name)
    end
end
