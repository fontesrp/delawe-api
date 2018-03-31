class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user_id

  def show

    if current_user.id == @user_id
      user = current_user
    elsif current_user.user_type == 'admin'
      user = User.find @user_id
    else
      return head :unauthorized
    end

    render json: user.attributes.except('password_digest')
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
