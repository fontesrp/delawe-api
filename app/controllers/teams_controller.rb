class TeamsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_target_user

  def index

    couriers = @target_user
      .couriers
      .near [@target_user.latitude, @target_user.longitude], 1000, units: :km

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

  private

  def set_target_user
    if current_user.user_type == 'admin' && params[:user_id].present?
      @target_user = User.find params[:user_id]
    else
      @target_user = current_user
    end
  end
end
