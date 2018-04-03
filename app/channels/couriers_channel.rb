class CouriersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "couriers_store_#{current_user.id}"
  end
end
