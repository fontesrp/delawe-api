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
      .near [@target_user.latitude, @target_user.longitude], 1000, units: :km

    props = orders.map do |order|
      att = order.attributes
      att['courier_first_name'] = order.courier&.first_name
      att['courier_last_name'] = order.courier&.last_name
      att
    end

    render json: props
  end

  def create

    store = User.find params[:store_id]

    @order = Order.new order_params
    @order.store = store

    if !@order.save
      render json: { errors: @order.errors.full_messages }
    elsif !params[:courier_id].present?
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
    elsif !@order.update order_params
      render json: { errors: @order.errors.full_messages }
    elsif !action.present?
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
    if @order.method(action).call
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }
    end
  end

end
