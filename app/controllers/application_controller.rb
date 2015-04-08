class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def is_admin?
    unless current_user.is? "系统管理员"
      flash[:notice] = "您的权限不足，请联系系统管理员，谢谢！"
      redirect_to '/' 
    end
    true
  end

  def can_access role
    if current_user.is? role
      true
    else
      is_admin?
    end
  end
end
