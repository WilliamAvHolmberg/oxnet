class RsWorldsController < ApplicationController
  before_action :set_rs_world, only: [:show, :edit, :update, :destroy]

  # GET /rs_worlds
  # GET /rs_worlds.json
  def index
    # ActiveRecord::Base.connection.execute("SELECT setval('rs_worlds_id_seq', (SELECT MAX(id) FROM rs_worlds)+1);")
    @rs_worlds = RsWorld.order(:number).all
  end

  # GET /rs_worlds/1
  # GET /rs_worlds/1.json
  def show
  end

  # GET /rs_worlds/new
  def new
    @rs_world = RsWorld.new
  end

  # GET /rs_worlds/1/edit
  def edit
  end

  # POST /rs_worlds
  # POST /rs_worlds.json
  def create
    @rs_world = RsWorld.new(rs_world_params)

    respond_to do |format|
      if @rs_world.save
        format.html { redirect_to @rs_world, notice: 'Rs world was successfully created.' }
        format.json { render :show, status: :created, location: @rs_world }
      else
        format.html { render :new }
        format.json { render json: @rs_world.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rs_worlds/1
  # PATCH/PUT /rs_worlds/1.json
  def update
    respond_to do |format|
      if @rs_world.update(rs_world_params)
        format.html { redirect_to @rs_world, notice: 'Rs world was successfully updated.' }
        format.json { render :show, status: :ok, location: @rs_world }
      else
        format.html { render :edit }
        format.json { render json: @rs_world.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rs_worlds/1
  # DELETE /rs_worlds/1.json
  def destroy
    replacement = RsWorld.all.where.not(id: params[:id]).sample
    Account.where('banned=false AND created=true').where(rs_world_id: params[:id]).update_all(rs_world_id: replacement.id)
    Account.where(rs_world_id: params[:id]).update_all(rs_world_id: replacement.id)

    @rs_world.destroy
    respond_to do |format|
      format.html { redirect_to rs_worlds_url, notice: 'Rs world was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rs_world
      @rs_world = RsWorld.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rs_world_params
      params.require(:rs_world).permit(:number, :members_only)
    end
end
