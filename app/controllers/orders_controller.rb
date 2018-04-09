class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_target_user

  def index

    if @target_user.user_type == 'store'
      filter = { store: @target_user }
    else
      filter = { courier: @target_user }
    end

    orders = Order
      .where(filter)
      .near [@target_user.latitude, @target_user.longitude], 20038, units: :km

    props = orders.map do |order|
      att = order.attributes
      att['courier_first_name'] = order.courier&.first_name
      att['courier_last_name'] = order.courier&.last_name
      att
    end

    render json: props
  end

  def create

    if @target_user.user_type != 'store'
      head :unauthorized
    end

    @order = Order.new order_params
    @order.store = @target_user

    if !@order.save
      render json: { errors: @order.errors.full_messages }
    elsif !params[:courier_id].present?
      broadcast
      render json: @order
    else
      set_courier
      perform_order_action 'assign!'
    end
  end

  def update

    @order = Order.find params[:id]
    action = params[:upd_action]

    if (
      @target_user.user_type != 'admin' &&
      @target_user != @order.courier &&
      @target_user != @order.store
    )
      head :unauthorized
    elsif params[:order].present? && !@order.update(order_params)
      render json: { errors: @order.errors.full_messages }
    elsif !action.present?
      broadcast
      render json: @order
    else
      case action
      when 'assign', 'reassign'
        set_courier
      when 'unassign'
        @order.courier = nil
      end

      perform_order_action "#{action}!"
    end
  end

  private

  def set_target_user
    if current_user.user_type == 'admin' && params[:user_id].present?
      @target_user = User.find params[:user_id]
    else
      @target_user = current_user
    end
  end

  def order_params
    params.require(:order).permit :address, :value
  end

  def set_courier

    courier = User.find params[:courier_id]

    @order.courier = courier
  end

  def perform_order_action(action)
    prev_aasm_state = @order.aasm_state
    if @order.method(action).call
      broadcast action, prev_aasm_state
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }
    end
  end

  def broadcast(action = nil, prev_aasm_state = nil)

    order = Order
      .where(id: @order.id)
      .near([@target_user.latitude, @target_user.longitude], 20038, units: :km)
      .first

    props = order.attributes

    unless action.nil?
      props['action'] = action
      props['prev_aasm_state'] = prev_aasm_state
    end

    ActionCable.server.broadcast "orders_user_#{@order.store.id}", props

    if order.courier.present?
      ActionCable.server.broadcast "orders_user_#{@order.courier.id}", props
    end
  end

end
