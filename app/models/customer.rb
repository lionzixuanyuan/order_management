class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :name
  validates_presence_of :address
  validates_uniqueness_of :name

  def show_text
    "#{name} - #{phone || '无联系电话'} - #{consignee || '无收件人'}"
  end
end
