class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_user_#{current_user.id}"
  end
end
