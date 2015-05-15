class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :orders, foreign_key: "creator_id"
  has_many :pandding_logs

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(match_roles)
    match_roles.split.each{|r| return true if roles.include?(r.to_s)}
    false
  end

  # def self.customer_servers
  #   User.all.collect{|u| u if u.roles.include? "前台客服"}.compact
  # end
end
