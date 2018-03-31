class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user_id, except: :index

  def show
    if current_user.id == @user_id
      render json: current_user.attributes.except('password_digest')
    else
      head :unauthorized
    end
  end

  def index

    if current_user.user_type == 'courier'
      return head :unauthorized
    end

    couriers = current_user
      .couriers
      .near([current_user.latitude, current_user.longitude], 1000, units: :km)

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

  def update

    if current_user.id == @user_id
      user = current_user
      update_params = user_params
    elsif current_user.type == 'admin'
      user = User.find @user_id
      update_params = admin_params
    else
      return head :unauthorized
    end

    if user.update update_params
      render json: user.attributes.except('password_digest')
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  private

  def set_user_id
    @user_id = params[:id].to_i
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :address,
      :latitude,
      :longitude,
      :business_name,
      :phone
    )
  end

  def admin_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :user_type,
      :password,
      :address,
      :latitude,
      :longitude,
      :business_name,
      :phone,
      :balance
    )
  end
end
