class UsersController < ApplicationController
  # before_action :authorize, except: [:new, :create]
  skip_before_action :authorize, only: [:new, :create]
  before_action :is_admin?, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    unless (current_user == @user) || (current_user.is? "系统管理员")
      flash[:notice] = "您的权限不足，请联系系统管理员，谢谢！"
      redirect_to '/'
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = "注册成功"
      redirect_to '/'
    else
      flash[:notice] = "注册失败：#{user.errors.full_messages.join('；')}"
      redirect_to '/signup'
    end
  end

  def update
    @user.roles = params[:user][:roles] unless params[:user][:roles].blank?
    if @user.update(user_params)
      redirect_to @user, notice: "用户信息变更成功！"
    else
      redirect_to @user, notice: "用户信息变更失败：#{@user.errors.full_messages.join('；')}！"
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :roles)
  end 

  def set_user
    @user = User.find params[:id]
  end
end
