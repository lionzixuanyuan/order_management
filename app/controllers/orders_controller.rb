class OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :print_order, :edit, :update, :destroy,
                                    :to_pand, :pand_pass, :pand_back,
                                    :to_deliver, :to_cancel, :fancybox_show ]
  before_action(only: [:new, :create, :edit, :update]) { can_access("前台客服") }
  before_action(only: :destroy) { can_access("财务部门") }

  # GET /orders
  # GET /orders.json
  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result(distinct: true).includes(:customer).page(params[:page])
    # @orders = Order.page(params[:page])
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  def fancybox_show
    render layout: "content"
  end

  def print_order
    render layout: "print"
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.creator = current_user
    @order.order_details.build
  end

  # GET /orders/1/edit
  def edit
    unless @order.may_submit?
      flash[:notice] = "目前该订单的状态不允许进行编辑操作！"
      redirect_to '/' 
    end
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: '订单删除成功！' }
      format.json { head :no_content }
    end
  end

  # 提交审核
  def to_pand
    raise "当前用户不能进行这个操作！" unless current_user.is?("前台客服 系统管理员")
    raise "不能提交审核，请检查该记录的状态！" unless @order.may_submit?
    if @order.submit!
      render json: {msg: "提交审核操作成功！", state: @order.state_cn}
    else
      raise "发生异常，操作失败！"
    end
  rescue Exception => e
    render json: {msg: "#{e}"}.to_json
  end

  # 审核通过
  def pand_pass
    raise "当前用户不能进行这个操作！" unless current_user.is?("财务部门 系统管理员")
    raise "不能审核，请检查该记录的状态！" unless @order.may_pass?
    if @order.pass!
      render json: {msg: "审核通过操作成功！", state: @order.state_cn}
    else
      raise "发生异常，操作失败！"
    end
  rescue Exception => e
    render json: {msg: "#{e}"}.to_json
  end

  # 审核不通过
  def pand_back
    raise "当前用户不能进行这个操作！" unless current_user.is?("财务部门 仓库 系统管理员")
    raise "不能审核，请检查该记录的状态！" unless @order.may_reject?
    raise "审核驳回理由不能为空！" if params[:reason].blank?
    ActiveRecord::Base.transaction do
      PanddingLog.create!(order: @order, user: current_user, reason: params[:reason])
      if @order.reject!
        render json: {msg: "审核驳回操作成功！", state: @order.state_cn}
      else
        raise "发生异常，操作失败！"
      end
    end
  rescue Exception => e
    render json: {msg: "#{e}"}.to_json
  end

  # 发货
  def to_deliver
    raise "当前用户不能进行这个操作！" unless current_user.is?("仓库 系统管理员")
    raise "物流编号不能为空！" if params[:shipment_code].blank?
    @order.shipment_code = params[:shipment_code]
    raise "不能发货，请检查该记录的状态！" unless @order.may_deliver?
    if @order.deliver!
      render json: {msg: "发货操作成功！", state: @order.state_cn}
    else
      raise "发生异常，操作失败！"
    end
  rescue Exception => e
    render json: {msg: "#{e}"}.to_json
  end

  # 作废
  def to_cancel
    raise "当前用户不能进行这个操作！" unless current_user.is?("前台客服 系统管理员")
    raise "不能作废，请检查该记录的状态！" unless @order.may_cancel?
    if @order.cancel!
      render json: {msg: "作废操作成功！", state: @order.state_cn}
    else
      raise "发生异常，操作失败！"
    end
  rescue Exception => e
    render json: {msg: "#{e}"}.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:code, :customer_id, :totle_amount, :totle_sum, :inceptor, :saleman, :creator_id, :state, :order_details_attributes => [:id, :product_id, :amount, :discount, :sum, :_destroy])
    end
end
