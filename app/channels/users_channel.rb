class UsersChannel < ApplicationCable::Channel

  def subscribed
    stream_from "users_user_#{current_user.id}"
  end

  def receive(params)

    user_params = {
      latitude: params['latitude'],
      longitude: params['longitude']
    }

    if current_user.user_type == 'courier' && current_user.update(user_params)

      ActionCable.server.broadcast(
        "users_user_#{current_user.store.id}",
        current_user.attributes.extract!('id', 'latitude', 'longitude')
      )

    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
