class User < ActiveRecord::Base
  has_secure_password
  # validates :email, presence: {message: "邮箱不能为空！"}
  # validates :email, uniqueness: {message: "该邮箱已被注册！"}
  # validates :name, presence: {message: "用户名不能为空！"}
  validates :name, presence: true 
  validates :email, presence: true 
  validates :email, uniqueness: true 

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end
end
