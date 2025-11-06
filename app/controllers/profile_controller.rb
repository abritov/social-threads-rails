class ProfileController < ApplicationController
  before_action :authenticate_user!
  
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:name, :email, :avatar, :bio, :username])
  end
end
