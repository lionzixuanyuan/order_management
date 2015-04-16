class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :name
  validates_presence_of :address
  validates_uniqueness_of :name
end
