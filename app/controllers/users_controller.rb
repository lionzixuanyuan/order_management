class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create]
  before_action :is_admin?, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
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
    if @user.update(user_params)
      redirect_to @user, notice: '用户信息变更成功！'
    else
      redirect_to @user, notice: '用户信息变更失败！'
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def set_user
    @user = User.find params[:id]
  end
end
