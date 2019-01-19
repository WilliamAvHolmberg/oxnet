class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json

  def index
    @tasks = Task.where(schema: Schema.where(name: "RSPEER").first)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end



  # GET /tasks/new
  def new
    @task = Task.new
    @areas = Area.all
    @task_types = TaskType.all
    @items = RsItem.all
    @break_conditions = BreakCondition.all
    @time_intervalls = TimeInterval.all
    @schemas = Schema.where(default: false)
    3.times {@task.requirements.build}
  end

  # GET /tasks/1/edit
  def edit
    @time_intervalls = TimeInterval.all
    @areas = Area.all
    @task_types = TaskType.all
    @items = RsItem.all
    @break_conditions = BreakCondition.all
    @schemas = Schema.all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    @areas = Area.all
    @task_types = TaskType.all
    @items = RsItem.all
    @break_conditions = BreakCondition.all
    @schemas = Schema.all

    @source = Task.find(params[:id])
    @task = @source.dup
    render 'new'
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @areas = Area.all
    @task_types = TaskType.all
    @items = RsItem.all
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :bank_area_id, :action_area_id, :task_type_id, :axe_id, :treeName,
                                   :break_condition_id, :break_after, :start_time, :end_time, :schema_id, :monster_name,
                                   :gear_id, :food_id, :inventory_id, :loot_threshold, :skill_id, :quest_id, :ores, :search,
                                   :requirements_attributes => [:level, :skill_id, :task])
    end
end
