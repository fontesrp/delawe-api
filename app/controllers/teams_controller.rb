class TeamsController < ApplicationController

  before_action :authenticate_user!

  def index

    if current_user.user_type == 'admin' && params[:user_id].present?
      user = User.find params[:user_id]
    else
      user = current_user
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
