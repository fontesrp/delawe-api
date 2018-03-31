class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_target_user

  def show
    render json: @target_user.attributes.except('password_digest')
  end

  def update
    if @target_user.update update_params
      render json: @target_user.attributes.except('password_digest')
    else
      render json: { errors: @target_user.errors.full_messages }
    end
  end

  private

  def set_target_user

    user_id = params[:id].to_i

    if current_user.id == user_id
      @target_user = current_user
    elsif current_user.user_type == 'admin'
      @target_user = User.find user_id
    else
      head :unauthorized
    end
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
