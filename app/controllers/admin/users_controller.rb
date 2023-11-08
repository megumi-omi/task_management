class Admin::UsersController < ApplicationController
   before_action :user_check

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "一般ユーザを作成しました"
      redirect_to admin_users_path
    else
      flash[:danger] = "ユーザ作成に失敗しました"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      flash[:notice] = "ユーザ情報を更新しました"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "ユーザを削除しました"
    redirect_to admin_users_path
  end
 #名前変える
  def user_check
    if current_user.admin
    else 
      redirect_to tasks_path
      flash[:danger] = "管理者以外アクセスできません"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
