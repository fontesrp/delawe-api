class TeamsController < ApplicationController

  def index

    user_id = params[:user_id].to_i

    if current_user.id == user_id
      user = current_user
    elsif current_user.user_type == 'admin'
      user = User.find user_id
    else
      return head :unauthorized
    end

    couriers = user
      .couriers
      .near [user.latitude, user.longitude], 1000, units: :km

    props = couriers.map do |cour|
      {
        id: cour.id,
        first_name: cour.first_name,
        last_name: cour.last_name,
        latitude: cour.latitude,
        longitude: cour.longitude,
        distance: cour.distance,
        last_pickup: cour.last_order&.created_at
      }
    end

    render json: props
  end
end
