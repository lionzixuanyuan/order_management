class Product < ActiveRecord::Base
  include AASM

  has_many :order_details

  validates_presence_of :name
  validates_presence_of :unit
  validates_presence_of :price
  validates_uniqueness_of :name

  scope :published, -> {
    where(aasm_state: "published")
  }

  STATE_HASH = {
    published: "可用",
    deleted: "已删除"
  }.freeze

  aasm do
    state :published, :initial => true
    state :deleted

    # 删除产品
    event :offline do
      transitions :from => :published, :to => :deleted
    end

    # 恢复删除的产品
    event :online do
      transitions :from => :deleted, :to => :published
    end
  end
end
