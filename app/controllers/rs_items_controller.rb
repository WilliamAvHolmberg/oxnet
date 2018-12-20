class RsItemsController < ApplicationController
  before_action :set_rs_item, only: [:show, :edit, :update, :destroy]

  # GET /rs_items
  # GET /rs_items.json
  def index
    @rs_items = RsItem.search(params[:search])
  end

  # GET /rs_items/1
  # GET /rs_items/1.json
  def show
  end

  # GET /rs_items/new
  def new
    @rs_item = RsItem.new
  end

  # GET /rs_items/1/edit
  def edit
  end

  # POST /rs_items
  # POST /rs_items.json
  def create
    @rs_item = RsItem.new(rs_item_params)

    respond_to do |format|
      if @rs_item.save
        format.html { redirect_to @rs_item, notice: 'Rs item was successfully created.' }
        format.json { render :show, status: :created, location: @rs_item }
      else
        format.html { render :new }
        format.json { render json: @rs_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rs_items/1
  # PATCH/PUT /rs_items/1.json
  def update
    respond_to do |format|
      if @rs_item.update(rs_item_params)
        format.html { redirect_to @rs_item, notice: 'Rs item was successfully updated.' }
        format.json { render :show, status: :ok, location: @rs_item }
      else
        format.html { render :edit }
        format.json { render json: @rs_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rs_items/1
  # DELETE /rs_items/1.json
  def destroy
    @rs_item.destroy
    respond_to do |format|
      format.html { redirect_to rs_items_url, notice: 'Rs item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rs_item
      @rs_item = RsItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rs_item_params
      params.require(:rs_item).permit(:item_id, :item_name, :search)
    end
end
