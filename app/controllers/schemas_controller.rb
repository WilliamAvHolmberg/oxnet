class SchemasController < ApplicationController
  before_action :set_schema, only: [:show, :edit, :update, :destroy]

  # GET /schemas
  # GET /schemas.json
  def index
    # @schemas = Schema.where(default: false)

    ####CLEANUP FUNCTION - SUPER QUICK###
    orphans = Schema.where(disabled: false).where([ "id NOT IN (?)", Account.select(:schema_id).where(banned: false, created: true)])
    orphans.update_all(disabled: true)

    @schemas = Schema.ordered_by_use

  end

  # GET /schemas/1
  # GET /schemas/1.json
  def show
  end

  # GET /schemas/new
  def new
    @schema = Schema.new
  end

  def move_down_task
    @schema = Schema.find(params[:id])
    task = Task.find(params[:task_id])
    task.move_lower
    render 'show'
  end
  def move_up_task
    @schema = Schema.find(params[:id])
    task = Task.find(params[:task_id])
    task.move_higher
    render 'show'
  end
  def remove_task
    @schema = Schema.find(params[:id])
    task = Task.find(params[:task_id])
    @schema.tasks.delete(task)
    @schema.save
    render 'show'
  end
  def copy
    @source = Schema.find(params[:id])
    @schema = @source.dup
    @schema.save
    @schema.tasks.destroy
    if @source.tasks != nil
      @source.tasks.each do |task|
        puts "putting object"
        new_task = task.dup
        new_task.update(:schema_id => @schema.id)
        new_task.save
      end
    end
    render 'new'
  end

  # GET /schemas/1/edit
  def edit
  end

  # POST /schemas
  # POST /schemas.json
  def create
    @schema = Schema.new(schema_params)

    respond_to do |format|
      if @schema.save
        format.html { redirect_to @schema, notice: 'Schema was successfully created.' }
        format.json { render :show, status: :created, location: @schema }
      else
        format.html { render :new }
        format.json { render json: @schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schemas/1
  # PATCH/PUT /schemas/1.json
  def update
    respond_to do |format|
      if @schema.update(schema_params)
        format.html { redirect_to @schema, notice: 'Schema was successfully updated.' }
        format.json { render :show, status: :ok, location: @schema }
      else
        format.html { render :edit }
        format.json { render json: @schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schemas/1
  # DELETE /schemas/1.json
  def destroy
    @schema.destroy
    respond_to do |format|
      format.html { redirect_to schemas_url, notice: 'Schema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schema
      @schema = Schema.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schema_params
      params.require(:schema).permit(:name, :task_id, :default, :max_slaves)
    end


end
