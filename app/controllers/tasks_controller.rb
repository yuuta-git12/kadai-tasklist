class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy,:show,:update,:edit]
  
  def index
      @tasks = Task.order(created_at: :asc).page(params[:page]).per(3)
  end

  def show
      
  end

  def new
      @task = Task.new
  end

  def create
      #@task = Task.new(task_params)
      
       @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'タスクが正常に追加されました'
      #redirect_to @task
      
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクが追加されませんでした'
      #render :new
      render 'toppages/index'
    end
  end

  def edit
      
  end

  def update
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
    #redirect_back(fallback_location: root_path) 前に書いてあるのアクションが実行されたページに戻るメソッド
    redirect_to root_url
  end

  private
  
  def set_task
    @task = Task.find(params[:id])
  end

 # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end


end