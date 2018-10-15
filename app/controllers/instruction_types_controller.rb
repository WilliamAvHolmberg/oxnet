class InstructionTypesController < ApplicationController
  before_action :set_instruction_type, only: [:show, :edit, :update, :destroy]

  # GET /instruction_types
  # GET /instruction_types.json
  def index
    @instruction_types = InstructionType.all
  end

  # GET /instruction_types/1
  # GET /instruction_types/1.json
  def show
  end

  # GET /instruction_types/new
  def new
    @instruction_type = InstructionType.new
  end

  # GET /instruction_types/1/edit
  def edit
  end

  # POST /instruction_types
  # POST /instruction_types.json
  def create
    @instruction_type = InstructionType.new(instruction_type_params)

    respond_to do |format|
      if @instruction_type.save
        format.html { redirect_to @instruction_type, notice: 'Instruction type was successfully created.' }
        format.json { render :show, status: :created, location: @instruction_type }
      else
        format.html { render :new }
        format.json { render json: @instruction_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instruction_types/1
  # PATCH/PUT /instruction_types/1.json
  def update
    respond_to do |format|
      if @instruction_type.update(instruction_type_params)
        format.html { redirect_to @instruction_type, notice: 'Instruction type was successfully updated.' }
        format.json { render :show, status: :ok, location: @instruction_type }
      else
        format.html { render :edit }
        format.json { render json: @instruction_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instruction_types/1
  # DELETE /instruction_types/1.json
  def destroy
    @instruction_type.destroy
    respond_to do |format|
      format.html { redirect_to instruction_types_url, notice: 'Instruction type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruction_type
      @instruction_type = InstructionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instruction_type_params
      params.require(:instruction_type).permit(:name)
    end
end
