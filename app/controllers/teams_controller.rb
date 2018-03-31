class TeamsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_target_user

  def index

    couriers = @target_user
      .couriers
      .near [@target_user.latitude, @target_user.longitude], 1000, units: :km

    props = couriers.map do |cour|
      cour_props = cour.attributes.extract!(
        'id',
        'first_name',
        'last_name',
        'latitude',
        'longitude',
        'distance'
      )
      cour_props['last_pickup'] = cour.last_order&.created_at
      cour_props
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
