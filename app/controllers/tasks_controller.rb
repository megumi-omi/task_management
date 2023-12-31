class TasksController < ApplicationController

  def index
    @tasks = current_user.tasks
    # タイトル/ステータス/ラベル検索
    if params[:search].present?
      @tasks = @tasks.search_title(params[:search][:title]) if params[:search][:title].present?
      @tasks = @tasks.search_status(params[:search][:status]) if params[:search][:status].present?
      @tasks = @tasks.joins(:labels).where(labels:{id:params[:search][:label_id]}) if params[:search][:label_id].present?
    end
    # 終了期限・優先順位でソート
    if params[:sort_deadline].present?
      @tasks = @tasks.order(deadline: :desc)
    elsif params[:sort_priority].present?
      @tasks = @tasks.order(priority: :asc)
    else
      @tasks = @tasks.order(created_at: :desc)
    end
    # ページネーション
    @tasks = @tasks.page(params[:page]).per(5) 
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました"
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, label_ids:[])
  end
end
