module ApplicationHelper
  def can_access role
    current_user.is?(role) || current_user.is?("系统管理员")
  end
end
