class InstructionsController < ApplicationController
  before_action :set_instruction, only: [:show, :edit, :update, :destroy]
  # GET /instructions
  # GET /instructions.json
  def index
    now = Time.now.utc
    @instructions = Instruction.where(completed: false, created_at: now-60.minutes..now)
  end

  # GET /instructions/1
  # GET /instructions/1.json
  def show
  end

  # GET /instructions/new
  def new
    @available_accounts = Account.all.select {|acc| acc.is_available && !acc.banned}
    @available_computers = Computer.all.select {|comp| comp.is_connected}
    @instruction = Instruction.new
    @scripts = Script.all
  end

  # GET /instructions/1/edit
  def edit
  end

  # POST /instructions
  # POST /instructions.json
  def create
    @instruction = Instruction.new(instruction_params)

    respond_to do |format|
       if @instruction.save
        format.html { redirect_to @instruction, notice: 'Instruction was successfully created.' }
        format.json { render :show, status: :created, location: @instruction }
      else
        format.html { render :new }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_accounts
    @available_computers
    @instruction
    puts "called"
    instruction_type_id = params[:instruction_type_id]
    computer_id = params[:computer_id]
    puts instruction_type_id
    ##2 == new client
    ##3 == disconnect client
    if instruction_type_id == "2"
      puts "conn"
      @available_accounts = Account.all.select {|acc| acc.is_available}
    elsif instruction_type_id == "3"
      puts "disco"
      @available_accounts = Account.all.select {|acc| !acc.is_available}
    end
  end

  # PATCH/PUT /instructions/1
  # PATCH/PUT /instructions/1.json
  def update
    respond_to do |format|
      if @instruction.update(instruction_params)
        format.html { redirect_to @instruction, notice: 'Instruction was successfully updated.' }
        format.json { render :show, status: :ok, location: @instruction }
      else
        format.html { render :edit }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructions/1
  # DELETE /instructions/1.json
  def destroy
    @instruction.destroy
    respond_to do |format|
      format.html { redirect_to instructions_url, notice: 'Instruction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instruction_params
      params.require(:instruction).permit(:instruction_type_id, :computer_id, :account_id, :script_id)
    end
end
