class Order < ActiveRecord::Base
  include AASM

  # validates :code, presence: true
  validates :customer_id, presence: true
  validates :totle_amount, presence: true
  validates :totle_sum, presence: true
  validates :saleman, presence: true

  has_many :order_details
  has_many :pandding_logs
  belongs_to :customer
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  accepts_nested_attributes_for :order_details, :allow_destroy => true

  before_create :set_code

  def set_code
    prefix = Time.now.strftime('%Y%m')
    last_serial = (Order.where("code like ?", "#{prefix}%").last.code[6, 4].to_i rescue 0)
    serial = (last_serial + 1).to_s.rjust(4, "0") 
    self.code = prefix + serial
  end

  STATE_HASH = {
    creating: "待提交",
    panding: "审核中",
    passed: "审核通过",
    delivered: "已发货",
    cancelled: "作废"
  }.freeze

  def state_cn
    STATE_HASH[self.aasm_state.to_sym]
  end

  aasm do
    state :creating, :initial => true
    state :panding
    state :passed
    state :delivered
    state :cancelled

    # 提交审核
    event :submit do
      transitions :from => :creating, :to => :panding
    end

    # 审核通过
    event :pass do
      transitions :from => :panding, :to => :passed
    end

    # 审核不通过
    event :reject do
      transitions :from => :panding, :to => :creating
    end

    # 出货
    event :deliver do
      transitions :from => :passed, :to => :delivered
    end

    # 作废
    event :cancel do
      transitions :from => :creating, :to => :cancelled
    end
  end
end
