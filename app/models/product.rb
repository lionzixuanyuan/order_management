class Product < ActiveRecord::Base
  has_many :order_details

  validates_presence_of :name
  validates_presence_of :unit
  validates_presence_of :price
  validates_uniqueness_of :name
end
