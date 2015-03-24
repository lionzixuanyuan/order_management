class Order < ActiveRecord::Base
  has_many :order_details
  belongs_to :customer
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
end
