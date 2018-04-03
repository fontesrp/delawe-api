class TransactionsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "transactions_user_#{current_user.id}"
  end

  def receive(params)
    puts params[:data]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
